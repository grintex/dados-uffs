import scrapy
import os.path

class DownloadPrograms(scrapy.Spider):
    name = 'programs'
    start_urls = ['https://www.uffs.edu.br/graduacao/']

    def parse(self, response):
        for link in response.css('p.callout>a'):
            yield {
                'name': link.css('span::text').get(),
                'link': link.attrib['href'],
                'id': os.path.basename(link.attrib['href'])
            }