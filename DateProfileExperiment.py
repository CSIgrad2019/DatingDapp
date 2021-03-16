from DateCoin import convertDataToJSON, pinJSONtoIPFS, initContract, w3
import sys
#change all cryptofax to the DateCoin contract
DateCoin = initContract()

def createUpdateReport ():
    _usersName = input("What is your name: ")
    _userGender = input("How do you identify?: " )
    _userAge = int(input("What is your age?: "))
    _userBio = input("Tell us about yourself: ")
    _ipfsHash = input("After uploading a picture on IPFS please paste the IPFS link here: ")
    interested_in_female = input("Are you interested in females?: ")
    interested_in_male = input("Are you interested in males?: ")
    interested_in_other = input("Are you interested in other genders?: ")
    token_id = int(input("Token ID: "))

    json_data = convertDataToJSON(_usersName, _userGender, _userAge,
     _userBio, _ipfsHash, interested_in_female, interested_in_male,
      interested_in_other)

    _update_uri = pinJSONtoIPFS(json_data)

    return token_id, _update_uri, _usersName, _userGender, _userAge, _userBio, _ipfsHash, interested_in_female, interested_in_male, interested_in_other

userAddress = input(f'input your wallet address: ')

def userProfile(token_id, _update_uri, _usersName, _userGender, _userAge, _userBio, _ipfsHash, interested_in_female, interested_in_male, interested_in_other):
    txn_hash = DateCoin.functions.updateUser(_usersName,
     _userGender, _userAge, _userBio, _ipfsHash,
      interested_in_female, interested_in_male,
       interested_in_other, _update_uri).transact({"from": w3.eth.accounts[0]})

    txn_receipt = w3.eth.waitForTransactionReceipt(txn_hash)

    return txn_receipt

def getCompleteProfile(token_id):
    profile_filter = DateCoin.events.LogUpdateUser.createFilter(
        fromBlock="0x0", argument_filters={"userAddress": userAddress}
    )
    return profile_filter.get_all_entries()

def getInterestedProfiles(interested_in):
    profile_filter = DateCoin.events.LogUpdateUser.createFilter(
        fromBlock="latest", argument_filters={"interested_in" : interested_in}
    )
    return profile_filter.get_all_entries()

def getMatchedProfiles(_userGender):
    profile_filter = DateCoin.events.LogUpdateUser.createFilter(
        fromBlock="latest", argument_filters={"Gender" : _userGender}
    )
    return profile_filter.get_all_entries()

def main():
    if sys.argv[1] == "update":
        token_id, _update_uri, _usersName, _userGender, _userAge, _userBio, _ipfsHash, interested_in_female, interested_in_male, interested_in_other = createUpdateReport()

        txn_receipt = userProfile(token_id, _update_uri, _usersName, _userGender, _userAge, _userBio, _ipfsHash, interested_in_female, interested_in_male, interested_in_other)

        print(txn_receipt)
        print("update URI:", _update_uri)

    elif sys.argv[1] == "filter":
        interested_in_female, interested_in_male, interested_in_other = input(f'type in if what you are looking for, such as, 1 for female, 2 for male, or 3 for other: ' )
        gender = input(f'what is your gender?: ')
     #   interested_in = int(sys.argv[2, 3, 4])
     #   matches = getInterestedProfiles(interested_in)
        if interested_in_female == 1:
            userGender = female 
            match = getMatchedProfiles(userGender)
            if match[interested_in[-1]] == 1 and gender == 'female':
                print("here is a match", match)
            elif match[interested_in[-1]] == 2 and gender == 'male':
                print("here is a match", match)
            elif match[interested_in[-1]] == 3 and gender == 'other':
                print("here is a match", match)
        elif interested_in_male == 2:
            userGender = male
            match = getMatchedProfiles(userGender)
            if match[interested_in[-1]] == 1 and gender == 'female':
                print("here is a match", match)
            elif match[interested_in[-1]] == 2 and gender == 'male':
                print("here is a match", match)
            elif match[interested_in[-1]] == 3 and gender == 'other':
                print("here is a match", match)
        elif interested_in_other == 3:
            userGender = other
            match = getMatchedProfiles(userGender)
            if match[interested_in[-1]] == 1 and gender == 'female':
                print("here is a match", match)
            elif match[interested_in[-1]] == 2 and gender == 'male':
                print("here is a match", match)
            elif match[interested_in[-1]] == 3 and gender == 'other':
                print("here is a match", match) 

    elif sys.argv[1] == "get_update":
        token_id = int(sys.argv[2])
        allUsers = DateCoin.functions.allUsers(userAddress).call()
        update = getCompleteProfile(token_id)

        print(update)
        print("Profile Name, Gender, Age, Bio, Picture, and Interested in information for token_id #", allUsers[0], "has been updated for", allUsers[1] )
main()








