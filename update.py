from crypto import convertDataToJSON, pinJSONtoIPFS, initContract, w3
import sys

cryptofax = initContract()

def createUpdate ():
    date = input("date of the accident: ")
    description = input("Description of the accident: ")
    token_id = int(input("Token ID: "))

    json_data = convertDataToJSON(date, description)
    update_uri = pinJSONtoIPFS(json_data)

    return token_id, update_uri

def updateUser(token_id, update_uri):
    txn_hash = cryptofax.functions.updateUser(token_id,update_uri).transact({"from": w3.eth.accounts[0]})
    txn_receipt = w3.eth.waitForTransactionReceipt(txn_hash)

    return txn_receipt

def seeProfileUpdates(token_id):
    profile_filter = cryptofax.events.LogUpdateUser.createFilter(
        fromBlock="0x0", argument_filters={"token_id": token_id}
    )
    return profile_filter.get_all_entries()


def main():
    if sys.argv[1] == "update": 
            token_id, update_uri = createUpdate()
            profile = updateUser(token_id, update_uri)

            print(profile)
            print(f'update URI: {update_uri}')

    elif sys.argv[1] == "get":
        token_id = int(sys.argv[2])
        profile = cryptofax.functions.allUsers(token_id).call()
        profile_update = seeProfileUpdates(token_id)

        print(profile_update)
        print(profile[0], "has been updated to", profile[1])

main()