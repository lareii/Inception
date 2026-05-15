from http.server import HTTPServer, SimpleHTTPRequestHandler
import os

HOST = "0.0.0.0"
PORT = 4242
DIR = "/var/www/html"

os.chdir(DIR)

server = HTTPServer((HOST, PORT), SimpleHTTPRequestHandler)
server.serve_forever()
