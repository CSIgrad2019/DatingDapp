import requests
import json
#import os

#from dotenv import load_dotenv
from pathlib import Path

from web3.auto import w3

#load_dotenv()

pinata_api_key = "32cc79c7ad554c50443f"
pinata_secret_api_key = "76ef2af5bd6691f80edc0255b0952424e688a12b2f924ef067401219417dbd94"
cryptofax_address = "0x6aCa1e35d786D809543294012711D2BD5E171868"
headers = {
    "Content-Type": "application/json",
    "pinata_api_key": pinata_api_key,
    "pinata_secret_api_key": pinata_secret_api_key,
}


def initContract():
    with open(Path("CryptoFax.json")) as json_file:
        abi = json.load(json_file)

    return w3.eth.contract(address=cryptofax_address, abi=abi)


def convertDataToJSON(time, description, image):
    data = {
        "pinataOptions": {"cidVersion": 1},
        "pinataContent": {
            "name": "Example Profile",
            "description": description,
            "image": image,
            "time": time,
        },
    }
    return json.dumps(data)


def pinJSONtoIPFS(json):
    r = requests.post(
        "https://api.pinata.cloud/pinning/pinJSONToIPFS", data=json, headers=headers
    )
    ipfs_hash = r.json()["IpfsHash"]
    return f"ipfs://{ipfs_hash}"
