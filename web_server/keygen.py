import base64
import hashlib
import random

def gen_api_key():
    key = base64.b64encode(hashlib.sha256(str(random.getrandbits(256)).encode('utf-8')).digest(), random.choice(['rA', 'aZ', 'gQ', 'hH', 'hG', 'aR', 'DD']).encode('utf-8')).decode('utf-8').rstrip('=')
    return key
