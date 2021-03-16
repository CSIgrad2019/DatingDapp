import requests
import json
# import os

# from dotenv import load_dotenv
from pathlib import Path

from web3.auto import w3

# load_dotenv()

pinata_api_key = "193c5085d014ac725ebb"
pinata_secret_api_key = "a6ca8bdad93af5e509affc71e8861a7d16ad30295ba478b8e5692e8208422dcd"
DateCoin_address = "0xC0777C0aEa664bD6D55576069EFFE3680279d070" #the contract address of the contract after deployment

headers = {
    "Content-Type": "application/json",
    "pinata_api_key": pinata_api_key,
    "pinata_secret_api_key": pinata_secret_api_key,
}


def initContract():
    with open(Path("DatingCoin.json")) as json_file:  #Need DateCoin ABI saved as json file.
        abi = json.load(json_file)

    return w3.eth.contract(address=DateCoin_address, abi=abi)

#function to help us convert data to json.
def convertDataToJSON(Username,Gender, Age, Bio, Pic, Likes_females, Likes_males, Likes_others):
    data = {
        "pinataOptions": {"cidVersion": 1},
        "pinataContent": {
            "Name": Username,
            "Gender": Gender,
            "Age": Age,
            "Bio": Bio,
            "image": Pic,
            "Likes Females": Likes_females,
            "Likes Males": Likes_males,
            "Likes Others": Likes_others,
            "Update Uri" : "ipfs://bafybeicqfzuz7dzs22723pv6qnup4tggkv44w4icuhun6mkbngelho2mte",
        },
    }
    return json.dumps(data, indent=4)


def pinJSONtoIPFS(json):
    r = requests.post(
        "https://api.pinata.cloud/pinning/pinJSONToIPFS", data=json, headers=headers
    )
    ipfs_hash = r.json()["IpfsHash"]
    return f"ipfs://{ipfs_hash}"
