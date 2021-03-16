import requests
import json
# import os

# from dotenv import load_dotenv
from pathlib import Path

from web3.auto import w3

# load_dotenv()

pinata_api_key = "193c5085d014ac725ebb"
pinata_secret_api_key = "a6ca8bdad93af5e509affc71e8861a7d16ad30295ba478b8e5692e8208422dcd"
DateCoin_address = "0x72F4460668C6003b020c600D6158B992f089cdeB" #the contract address of the contract after deployment

headers = {
    "Content-Type": "application/json",
    "pinata_api_key": pinata_api_key,
    "pinata_secret_api_key": pinata_secret_api_key,
}


def initContract():
    with open(Path("DateCoin.json")) as json_file:  #Need DateCoin ABI saved as json file.
        abi = json.load(json_file)

    return w3.eth.contract(address=DateCoin_address, abi=abi)

#function to help us convert data to json.
def convertDataToJSON(Username,Gender, Age, Bio, Email):
    data = {
        "pinataOptions": {"cidVersion": 1},
        "pinataContent": {
            "usersName": Username,
            "image": "ipfs://NEED PICTURE OF SOMEONE",
            "userGender": Gender,
            "userAge": Age,
            "userBio": Bio,
            "userEmail": Email,
        },
    }
    return json.dumps(data)


def pinJSONtoIPFS(json):
    r = requests.post(
        "https://api.pinata.cloud/pinning/pinJSONToIPFS", data=json, headers=headers
    )
    ipfs_hash = r.json()["IpfsHash"]
    return f"ipfs://{ipfs_hash}"
