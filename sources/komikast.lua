--------------------------------
-- @name    komikast
-- @url     https://komikcast.vip
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
Base = "https://komikcast.vip"
Delay = 1 -- seconds
--- END VARIABLES ---



----- MAIN -----

--- Searches for manga with given query.
-- @param query string Query to search for
-- @return manga[] Table of mangas
function SearchManga(query)
    local url = Base .. "/?s=" .. query
    Page:navigate(url)
    Time.sleep(Delay)

    local mangas = {}
    --
    -- print(inspect(Page:html(".list-update_items-wrapper")));
    --
    for i, v in ipairs(Page:elements(".list-update_items-wrapper a")) do
        local elem = Html.parse(v:html())
        local manga = { url = v:attribute('href'), name = elem:find("h3.title"):text() }
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

    -- print(Page:has("#chapter-wrapper a.chapter-link-item"));
    local chapters = {}

    for i, v in ipairs(Page:elements("a.chapter-link-item")) do
        print(i)
        -- print(v:attribute('href'))
        -- local elem = Html.parse(v:html())
        local url = v:attribute("href")
        local chapter = { url = url, name = v:text() }
        chapters[i] = chapter
    end

    return chapters
end

--- Gets the list of all pages of a chapter.
-- @param chapterURL string URL of the chapter
-- @return page[]
function ChapterPages(chapterURL)
    Page:navigate(chapterURL)
    Time.sleep(Delay)


    -- print(Page:has(".page-break > img"))

    local pages = {}
    for i, v in ipairs(Page:elements(".page-break > img")) do
        local url = RemoveTabs(v:attribute("data-src"))
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
-- print(inspect(SearchManga('gosu')))
-- print(inspect(MangaChapters('https://komikcast.vip/komik/gosu/')))
-- print(inspect(ChapterPages("https://komikast.ae/series/disastrous-necromancer/chapter-01/")))
