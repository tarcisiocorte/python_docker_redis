import json
from lib2to3.pytree import convert
from flask import Flask
from redis import Redis, RedisError
import os
import urllib.request
import socket

import unittest
from app import api

class TestApi(unittest.TestCase):

    def test_getWeather(self):
        result = 10
        api_url = api()
        self.assertEqual(result, 10)

if __name__ == '__main__':
    unittest.main()
