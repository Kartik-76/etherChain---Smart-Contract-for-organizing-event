// in this contract there will be 2 entity i.e organizer and attendee. An organizer is an entity which can organize any entity and attendee who will attend the event.

// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract eventContract {
    struct Event{
        address organizer;
        string event_name;
        uint date;
        uint price;
        uint ticketCount;
        uint ticketRemain;
    }

    mapping(uint=>Event) public events;
    mapping(address=>mapping(uint=>uint)) public tickets;
    uint public nextId;

    function createEvent(string memory name, uint date, uint price, uint ticketCount) external {
        require(date>block.timestamp,"you can organize event for future date");
        require(ticketCount>0,"you can organize event only if you can create more than 0 tickets");

        events[nextId] = Event(msg.sender,name,date,price,ticketCount,ticketCount);
        nextId++;
    }

    function buyTicket(uint id, uint quantity) external payable{
        require(events[id].date!=0, "this event doesn't exist");
        require(events[id].date>block.timestamp,"Event has alread occurred");
        Event storage _event = events[id];
        require(msg.value==(_event.price*quantity),"Ether is not enough");
        require(_event.ticketRemain>=quantity,"Not Enough Tickets");
        _event.ticketRemain-=quantity;
        tickets[msg.sender][id]+=quantity;
    }

    function transferTicket(uint id,uint quantity, address to) external{
        require(events[id].date!=0, "this event doesn't exist");
        require(events[id].date>block.timestamp,"Event has alread occurred");
        require(tickets[msg.sender][id]>=quantity,"You do not have enough ticket to transfer");
        tickets[msg.sender][id]-=quantity;
        tickets[to][id]+=quantity;
    }
}