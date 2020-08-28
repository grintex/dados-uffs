import scrapy
import os, sys

class DownloadSourcePrograms(scrapy.Spider):
    name = 'source.programs'
    start_urls = ['https://www.uffs.edu.br/acessofacil/transparencia/servico-de-informacao-ao-cidadao-e-sic/grade-corpo-docente']

    def parse(self, response):
        for link in response.css('section#content-core a'):
            program_name = link.css('span::text').get()
            program_link = link.attrib['href']
            program_id = os.path.basename(link.attrib['href'])

            yield {
                'name': program_name,
                'link': program_link,
                'id': program_id
            }
