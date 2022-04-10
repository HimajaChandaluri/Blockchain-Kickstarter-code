pragma solidity ^0.8.9;

contract Project {
    struct Request {
        string description;
        uint value;
        address payable recipient;
        bool complete;
        mapping(address => bool) approvals;
        uint approvalCount;
    }

    address public manager;
    uint public minimumContribution;
    mapping(address => bool) public approvers;
    Request[] public requests;
    uint public approverCount;

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    constructor() {
        manager = msg.sender;
        minimumContribution = 0;
    }

    function contribute() public payable {
        // Check to verify that minimum contribution amount of ether has been sent with the transaction
        require(msg.value > minimumContribution);
        approvers[msg.sender] = true;
        approverCount++;
    }

    function createRequest(string memory description, uint value, address payable recipient) public restricted {
        Request storage newRequest = requests.push();
        newRequest.description = description;
        newRequest.value = value;
        newRequest.recipient = recipient;
        newRequest.complete = false;
        newRequest.approvalCount = 0;
    }

    function approveRequest(uint index) public {
        Request storage request = requests[index];

        require(approvers[msg.sender]);
        require(!request.approvals[msg.sender]);

        request.approvals[msg.sender] = true;
        request.approvalCount++;
    }

    function finalizeRequest(uint index) public restricted {
        Request storage request = requests[index];

        require((approverCount / 2) < request.approvalCount);
        require(!request.complete);
        
        request.recipient.transfer(request.value);
        request.complete = true;
    }

}