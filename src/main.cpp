#include<iostream>
#include "CFG/contract/Contract.h"
#include "Utils/JsonExporter.h"
#include<fstream>
#include "Message.h"

using namespace std;

string Message::ANSI_RESET = "\u001B[0m";
string Message::ANSI_YELLOW = "\u001B[33m";
bool Message::printDebug = false;

int main(){
    // string bytecode = "608060405260aa60005534801561001557600080fd5b50610184806100256000396000f3fe608060405234801561001057600080fd5b506004361061004c5760003560e01c80634b3df200146100515780635bfd987d1461006f578063c2985578146100b1578063febb0f7e146100cf575b600080fd5b6100596100ed565b6040518082815260200191505060405180910390f35b61009b6004803603602081101561008557600080fd5b810190808035906020019092919050505061011d565b6040518082815260200191505060405180910390f35b6100b961012a565b6040518082815260200191505060405180910390f35b6100d761013c565b6040518082815260200191505060405180910390f35b6000806000815480929190600101919050555060aa600054141561011557600054905061011a565b600080fd5b90565b6000816088019050919050565b600061013761cccc61011d565b905090565b600061014961dddd61011d565b90509056fea2646970667358221220e619b234c1887f9b10b567ee21364dbf523a19001c8c47a33049907c0398563164736f6c63430006040033";
    string bytecode = "608060405234801561001057600080fd5b50336000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff16021790555060008054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16600073ffffffffffffffffffffffffffffffffffffffff167f342827c97908e5e2f71151c08502a66d44b6f758e3ac2f1de95f02eb95f0a73560405160405180910390a3610356806100db6000396000f3fe608060405234801561001057600080fd5b50600436106100365760003560e01c8063893d20e81461003b578063a6f9dae114610059575b600080fd5b610043610075565b604051610050919061025d565b60405180910390f35b610073600480360381019061006e91906101fe565b61009e565b005b60008060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff16905090565b60008054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff161461012c576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040161012390610278565b60405180910390fd5b8073ffffffffffffffffffffffffffffffffffffffff1660008054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff167f342827c97908e5e2f71151c08502a66d44b6f758e3ac2f1de95f02eb95f0a73560405160405180910390a3806000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff16021790555050565b6000813590506101f881610309565b92915050565b600060208284031215610214576102136102db565b5b6000610222848285016101e9565b91505092915050565b610234816102a9565b82525050565b6000610247601383610298565b9150610252826102e0565b602082019050919050565b6000602082019050610272600083018461022b565b92915050565b600060208201905081810360008301526102918161023a565b9050919050565b600082825260208201905092915050565b60006102b4826102bb565b9050919050565b600073ffffffffffffffffffffffffffffffffffffffff82169050919050565b600080fd5b7f43616c6c6572206973206e6f74206f776e657200000000000000000000000000600082015250565b610312816102a9565b811461031d57600080fd5b5056fea2646970667358221220db8b7c376acedd6d9f0cde96114ef9145e7a9a1ab942d5a8285572a52c97636364736f6c63430008060033";
    string name = "Sample";
    Contract contract(name, bytecode);
    // Contract* contract = new Contract(name, bytecode);
    cout << "toString:\n" << contract.toString() << endl;
    cout << "getBytes:\n" << contract.getBytes() << endl;
    cout << "getBinarySource:\n" << contract.getBinarySource() << endl;
    cout << "getContractHash:\n" << contract.getContractHash() << endl;
    cout << "getMetadata:\n" << contract.getMetadata() << endl;
    cout << "getConstructorRemainingData:\n" << contract.getConstructorRemainingData() << endl;
    cout << "getExactSolidityVersion:\n" << contract.getExactSolidityVersion() <<endl;
    json output_test;
    try {
        output_test = JsonExporter::contractJsonWriter(contract);
        fstream _file;

        _file.open("../../outputs/json/"+contract.getContractHash()+".json", ios::in);
        if(!_file) {
            Message::printDebugFun("Output file will be created");
            try {
                ofstream ofs;
                ofs.open("../../outputs/json/"+contract.getContractHash()+".json", ios::out);
                ofs<<output_test.dump(4)<<endl;
                ofs.close();
                cout<<"Contract analysis exported in "<<contract.getContractHash()+".json"<<endl;
            } catch (exception e) {
                cerr<<"Error writing file"+contract.getContractHash()+": "+e.what();
            }
        }
    } catch (exception e) {
        cerr<<"error occurred: "<<e.what()<<endl;
    }

    return 0;
}