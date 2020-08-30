import scrapy
import os, sys
import re

from lxml import html
from lxml.html.clean import clean_html
from markdownify import markdownify as md

def basic_clean(data):
    return re.sub('@import .*', '', data)

def remove_html_comments(data):
    return re.sub('<!--.*-->', '', data)

class DownloadNotice(scrapy.Spider):
    name = 'download.notice'
    start_urls = []

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.start_urls = [f'{self.url}']

    def parse(self, response):
        for content in response.css('article#content'):
            doc_id = os.path.basename(self.url)

            doc_title_tree = html.fromstring(content.css('h1').get())
            doc_title = clean_html(doc_title_tree).text_content().strip()

            doc_content = basic_clean(content.css('section#content-core').get())

            doc_content_tree = html.fromstring(doc_content)
            doc_content_clean = clean_html(doc_content_tree).text_content().strip()
            doc_content_md = md(remove_html_comments(doc_content))
            
            with open(self.output + '/' + doc_id + '.html', 'w') as f:
                f.write(doc_content)

            with open(self.output + '/' + doc_id + '.md', 'w') as f:
                f.write(doc_content_md)

            with open(self.output + '/' + doc_id + '.plain', 'w') as f:
                f.write(doc_content_clean)
