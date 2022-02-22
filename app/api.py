import json
from lib2to3.pytree import convert
from flask import Flask
from redis import Redis, RedisError
import os
import urllib.request
REDIS_HOST = os.getenv("REDIS_HOST", "redis")

api_request = Flask(__name__)

redis = Redis(host=REDIS_HOST, db=0, socket_connect_timeout=2, socket_timeout=2)


@api_request.route('/weather/city/<city_id>')
def get_city_weather(city_id):
    if redis.get(city_id):
        result_json = redis.get(city_id)
        return result_json
    else:
        url = get_configuration() + city_id
        source = urllib.request.urlopen(url).read()
        result = json.loads(source)
        # save for 30 min
        redis.set(city_id, json.dumps(result), 1800)

        return redis.get(city_id)


def get_configuration():
    config = json.loads(os.environ['SERVICE_WEATHERAPI_CONFIG'])
    return config[0]["owm_list"][0]["domain"] + config[0]["owm_list"][0]["path"] + config[0]["owm_list"][0]["args"] + "&id="    


if __name__ == "__main__":
    api_request.run(host='0.0.0.0', port=5656)
