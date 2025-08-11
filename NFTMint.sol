// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Minimal NFT (ERC-721 like) for learning / demo
/// @notice Minimal, self-contained NFT contract with mint, transfer, approvals and tokenURI.
/// @dev This is a simplified implementation for demo and learning. Do not use on mainnet without audit.
contract NFTMint {
    // Basic token data
    string public name = "MuhammadNFT";
    string public symbol = "MFT";

    // token id => owner
    mapping(uint256 => address) private _owners;
    // owner => number of tokens
    mapping(address => uint256) private _balances;
    // token id => approved address
    mapping(uint256 => address) private _tokenApprovals;
    // owner => operator => approved
    mapping(address => mapping(address => bool)) private _operatorApprovals;
    // token id => metadata URI
    mapping(uint256 => string) private _tokenURIs;

    // total minted counter
    uint256 private _tokenIdCounter;

    // Events
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    // ------------------------
    // Basic ERC-721 functions
    // ------------------------

    function balanceOf(address owner) public view returns (uint256) {
        require(owner != address(0), "Zero address");
        return _balances[owner];
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "Token does not exist");
        return owner;
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        return _owners[tokenId] != address(0);
    }

    /// @notice Approve an address to transfer a specific token
    function approve(address to, uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(msg.sender == owner || isApprovedForAll(owner, msg.sender), "Not authorized");
        _tokenApprovals[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }

    function getApproved(uint256 tokenId) public view returns (address) {
        require(_exists(tokenId), "Nonexistent token");
        return _tokenApprovals[tokenId];
    }

    /// @notice Approve or remove operator for caller
    function setApprovalForAll(address operator, bool approved) public {
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function isApprovedForAll(address owner, address operator) public view returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    /// @notice Transfer token. Caller must be owner or approved.
    function transferFrom(address from, address to, uint256 tokenId) public {
        require(_isApprovedOrOwner(msg.sender, tokenId), "Not owner nor approved");
        require(ownerOf(tokenId) == from, "From not owner");
        require(to != address(0), "Invalid to");

        // Clear approvals
        _approve(address(0), tokenId);

        // Update balances and ownership
        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
        require(_exists(tokenId), "Nonexistent token");
        address owner = ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }

    function _approve(address to, uint256 tokenId) internal {
        _tokenApprovals[tokenId] = to;
        emit Approval(ownerOf(tokenId), to, tokenId);
    }

    // ------------------------
    // Minting & metadata
    // ------------------------

    /// @notice Mint a new token to `to` with `tokenURI`
    /// @dev tokenId is auto-incremented
    function mint(address to, string memory tokenURI) public returns (uint256) {
        require(to != address(0), "Invalid to");
        _tokenIdCounter += 1;
        uint256 newId = _tokenIdCounter;

        // Assign ownership
        _owners[newId] = to;
        _balances[to] += 1;
        _tokenURIs[newId] = tokenURI;

        emit Transfer(address(0), to, newId);
        return newId;
    }

    /// @notice Read token URI (metadata link)
    function tokenURI(uint256 tokenId) public view returns (string memory) {
        require(_exists(tokenId), "Nonexistent token");
        return _tokenURIs[tokenId];
    }

    /// @notice Convenience: total minted tokens
    function totalMinted() public view returns (uint256) {
        return _tokenIdCounter;
    }
}
