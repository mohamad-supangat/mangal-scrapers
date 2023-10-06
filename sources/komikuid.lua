--------------------------------
-- @name    komiku
-- @url     https://komiku.id
-- @author  deve
-- @license MIT
--------------------------------


----- IMPORTS -----
Html = require("html")
Headless = require('headless')
Time = require("time")
local inspect = require("inspect")
--- END IMPORTS ---




----- VARIABLES -----
Browser = Headless.browser()
Page = Browser:page()
Delay = 1 -- seconds
--- END VARIABLES ---



----- MAIN -----

--- Searches for manga with given query.
-- @param query string Query to search for
-- @return manga[] Table of mangas
function SearchManga(query)
    local url = "https://data.komiku.id/cari/?post_type=manga&s=" .. query
    Page:navigate(url)
    Time.sleep(Delay)

    local mangas = {}

    for i, v in ipairs(Page:elements(".daftar .kan > a")) do
        local manga = { url = v:attribute('href'), name = v:text() }
        mangas[i] = manga
    end

    return mangas
end

--- Gets the list of all manga chapters.
-- @param mangaURL string URL of the manga
-- @return chapter[] Table of chapters
function MangaChapters(mangaURL)
    Page:navigate(mangaURL)
    Time.sleep(Delay)

    local chapters = {}

    for i, v in ipairs(Page:elements("#Daftar_Chapter a")) do
        -- local elem = Html.parse(v:html())
        local url = v:attribute("href")
        local chapter = { url = "https://komiku.id" .. url, name = v:text() }
        chapters[i] = chapter
    end

    return ReverseList(chapters)
end

--- Gets the list of all pages of a chapter.
-- @param chapterURL string URL of the chapter
-- @return page[]
function ChapterPages(chapterURL)
    Page:navigate(chapterURL)
    Time.sleep(Delay)


    print(Page:has("#Baca_Komik img"))
    -- print(inspect(Page:elements("#Baca_Komik img")))

    local pages = {}
    for i, v in ipairs(Page:elements("#Baca_Komik img")) do
        local url = RemoveTabs(v:attribute("src"))
        local p = { index = i, url = url }
        pages[i] = p
    end

    return pages
end

--- END MAIN ---




----- HELPERS -----
function RemoveTabs(text)
    return text:gsub("\t", ""):gsub("\n", "")
end

function ReverseList(list)
    local reversed_list = {}
    for i = #list, 1, -1 do
        reversed_list[#reversed_list + 1] = list[i]
    end
    return reversed_list
end

--- END HELPERS ---

-- ex: ts=4 sw=4 et filetype=lua
--
--
-- print(inspect(SearchManga('villain')))
-- print(inspect(MangaChapters('https://komiku.id/manga/the-villain-of-destiny/')))
print(inspect(ChapterPages("https://komiku.id/ch/the-villain-of-destiny-chapter-105/")))
