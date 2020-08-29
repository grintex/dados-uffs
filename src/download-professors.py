import scrapy
import os, sys
import json

class DownloadProfessors(scrapy.Spider):
    name = 'download.professors'

    def __init__(self, link='', **kwargs):
        self.start_urls = [f'{link}']
        super().__init__(**kwargs)

    def parse(self, response):
        for row in response.css('table.listing tr')[1:]:
            professor_name = row.xpath('td[1]//span/text()').extract_first()
            professor_email = row.xpath('td[2]//span/text()').extract_first()
            professor_lattes = row.xpath('td[3]//span/text()').extract_first()

            if len(professor_name.strip()) == 0:
                next

            yield {
                'name': professor_name,
                'email': professor_email,
                'lattes': professor_lattes
            }
