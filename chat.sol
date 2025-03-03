// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ChatDapp {
    struct Message {
        address sender;
        string content;
        uint256 timestamp;
    }

    // Sự kiện thông báo có tin nhắn mới
    event NewMessage(address indexed sender, string content, uint256 timestamp);
    event PublicKeyRegistered(address indexed user, string publicKey);

    // Lưu trữ lịch sử tin nhắn giữa các địa chỉ
    mapping(address => Message[]) private chatHistory;
    mapping(address => string) public publicKeys;
    
    // Hàm gửi tin nhắn
    function sendMessage( string memory _content) public {
        require(bytes(_content).length > 0, "Message cannot be empty");
        // Tạo tin nhắn mới
        Message memory newMsg = Message({
            sender: msg.sender,
            content: _content,
            timestamp: block.timestamp
        });

        // Lưu tin nhắn vào lịch sử của người gửi 
        chatHistory[msg.sender].push(newMsg);

        // Phát sự kiện tin nhắn mới
        emit NewMessage(msg.sender, _content, block.timestamp);
    }
    // Hàm lấy lịch sử tin nhắn của người dùng hiện tại
    function getMessages() public view returns (Message[] memory) {
        return chatHistory[msg.sender];
    }

     // Đăng ký khóa công khai dưới dạng chuỗi
    function registerPublicKey(string memory _publicKey) public {
        publicKeys[msg.sender] = _publicKey;
        emit PublicKeyRegistered(msg.sender, _publicKey);
    }

    // Lấy khóa công khai
    function getPublicKey(address user) public view returns (string memory) {
        return publicKeys[user];
    }
}
