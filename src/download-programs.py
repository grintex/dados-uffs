import scrapy
import os, sys

class DownloadPrograms(scrapy.Spider):
    name = 'programs'
    start_urls = ['https://www.uffs.edu.br/acessofacil/transparencia/servico-de-informacao-ao-cidadao-e-sic/grade-corpo-docente']

    def parse(self, response):
        for link in response.css('#content-core > a'):
            yield {
                'name': link.css('span::text').get(),
                'link': link.attrib['href'],
                'id': os.path.basename(link.attrib['href'])
            }
