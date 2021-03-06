

<img src= images/crypto-love.jpg><br>
###### _Image source: https://miro.medium.com/max/700/0*XSb3YHGA26AJPbhm.jpg_
<p align="center">
    <ins><b>DateCoin - Love on the Block:</b><br><ins>
    <img src=images/DateCoin_Logo.PNG>
</p>

## Background
<p> Utilizing blockchain technology we have developed a dating Dapp that will allow greater security to its users by having a tiered structure of tokenized dating profiles using the ERC721 standard for NFTs (Non-Fungible Tokenization) allowing each user the ability to send & receive encrypted messages, match with users based on profile parameters on their token and a reduction of "user-bots" which currently represent a nuisance in current social-dating applications. 

In order to create this application we coded in two languages:
  
- Solidity for the creation of the smart contract, NFT and integration into the Ethereum blockchain network.
- Python for interactive deployment of the smart contract.

Several files were created in order to code the application:

- For Solidity we created the following files using REMIX: *DateCoin.sol, ProfileFunctions.sol and ProfileMessages.sol*
- For Python we created the following files using VScode: *DateCoin.py and DateProfile.py*

</p>

## Imports and Dependencies used with in our code

- *Remix* -  used to write solidity coded applications for Ethereum.
- *Web3* - used to connect ethereum based application to the local blockchain network.
- *Piñata* - application that stores files as ipfs.
- *JSON* - file type used to run solidity file in python.
- *IPFS* - Interplanetary File System.
- *OpenZeppelin* - Used to import dependencies used within solidity like ERC721, Counters.
- *Sys* - used to create an interactive prompt for a user in terminal/command prompt when running a python file.

## Deployment of the contracts:
<p> In order to deploy the Solidity contracts you must have all three .sol files mentioned above opened and compiled in REMIX. The compiling order should be ProfileMessages.sol first, then DatingProfileFunction and finally DateCoin. The compiling must be done in this order as each contract contains dependencies used by the other contracts and the contracts are being imported into each other in order to reduce the cost of deployment. 

After compiling you should Deploy the contract in order to begin creating the profile and creating your first token. 
- The deployment order should be Datecoin first and register the user and enter your wallet address. 
- Then go to updateUser and enter the profile information and select transaction. 

These steps will run via your metamask and create a coin that you can view in your Metamask wallet. 

## Profile Interface
<p> Using Python we were able to create a basic interactive user interface that runs on terminal that would allow the user to create a profile and using IPFS (Interplanetary File System) we were able to code the addition of an image that is necesary for a dating profile. The profile takes into account the basics for person to begin some kind of interaction with other users: Username, age, bio, email, and gender. In order to connect the required python files with the contract we had to use web3, the solidity contract ABI and create special functions that will convert the ABI to a json file to be read in python. Using Python, the user is able to update prpfiles and "get" the most recent profile as requested in the terminal command prompt. Unfortunately, we were unable to enable filtering with the python code and it is something we are looking to add in the future. 
  
<img src= images/New-ProfilePY.PNG>



## DatingCoin
As illustrated in the GIF below, in this file we created our coin (DATE) using the ERC721Full standard. We developed tiered profiles that change based on the amount of information the user inputs.



## Profile Functions
In the Profile Functions contract, we utilized the LogUpdateUser and inactiveUser functions in order to build the user profile and also to deactivate the user profile. Within the profile construction, we set up the ability to edit username, gender, age, bio, ipfs hash, and preference features. The reason we set up a deactivation funciton is because we anticipated users to have a higher churn rate. We also created this function in order to deactivate the profiles that are inactive after 30 days. Thus, a higher churn rate is a result of the more effective matching.

<img src= images/Profile_Functions.PNG>

## Profile Messages

In the ProfileMessages contract we created two structs that serve as a tier based system. These tiers allow users to input information about themselves in order to better serve our filtering system. Tier2 consisits of Ehtnicity, languages, zodiac,profession, and education level. Tier3 adds an additonal level of filter so users can have an increased chance of finding quality matches. tier3 consists of kids, looking for, religon, interests, and build. 

<img src= images/Message.PNG>

## Profile Tokenization
<p> In order to tokenize each profile we had to create a registeredUser function within the solidity file. This function is a public function that takes in the owner address as a parameter. The function then mints a token and takes in the users profile into the token as an empty profile that then needs to be filled in by the user when registereing. Each token is counted using the import Counter from OpenZeppellin as noted above. 
  
<img src= images/Tokenization.PNG>

## Conclusion:
<p> In conclusion, additional time is needed to make this project usable for the public as we are unable to create a user friendly frontend platform were the user can easily interact with the system as well as other users. We think with adequate time the solidity we are currently working with is sufficient to deploy a fully functional dating application that can be ready for the real world with minimal adjustments.


## Enjoy a quick Demo of the Solidity Contract Deployment:

<img src= images/DatingCoin-Demo.gif>




