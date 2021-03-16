from DateCoin import convertDataToJSON, pinJSONtoIPFS, initContract, w3
import sys
#change all cryptofax to the DateCoin contract
DateCoin = initContract()

def createUserProfile():
    #Name = input("What is your name: ")
    Username = input("Select a user name: ")
    Gender = input("How do you identify: " )
    Age = input("What is your age: ")
    Bio = input("Tell us about yourself: ")
    Email = input("What is your email address: ")
    token_id = int(input("Token ID: ")) #the number of the user that has registered in solidity.

    json_data = convertDataToJSON(Username, Gender, Age, Bio, Email)
    profile_uri = pinJSONtoIPFS(json_data) ##what uri are we using to create the profile?

    return token_id, profile_uri

def userprofile(_usersName, _userGender, _userBio,_ipfsHash, interested_in_female, interested_in_male, interested_in_other,  _update_uri):
    #txn_hash = DateCoin.functions.updateUser(token_id, profile_uri).transact({"from": w3.eth.accounts[0]})
    txn_hash = DateCoin.functions.updateUser(_usersName, _userGender, _userBio,_ipfsHash, interested_in_female, interested_in_male, interested_in_other,  _update_uri).transact({"from": w3.eth.accounts[0]})
    txn_receipt = w3.eth.waitForTransactionReceipt(txn_hash)

    return txn_receipt

def getCompleteProfile(token_id):
    profile_filter = DateCoin.events.LogUpdateUser.createFilter(
        fromBlock="0x0", argument_filters={"token_id": token_id}
    )
    return profile_filter.get_all_entries()


def main():
    if sys.argv[1] == "profile":
        token_id, profile_uri = createUserProfile()
        profile = createUserProfile()

        print(profile)
        print("Profile URI:", profile_uri)

    elif sys.argv[1] == "get":
        address = int(sys.argv[2])
        date = DateCoin.functions.registeredUser(address).transact()
        profile = getCompleteProfile(token_id)

        print(profile)
        print("Profile", date[0])

main()








