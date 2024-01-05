// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract jobPortal {
    
    address admin;
    constructor() {
        admin = msg.sender;
    }

    enum jobType {office, remote, hybrid}
    struct applicant_details{
        //Applicant Personal Details
        string name;
        uint phone;
        string home_address;
        uint8 age;
        uint8 rating;
        string skills;
        string work_exp;
        jobType job_preference;
        
    }

    struct job_details{
        string title;
        string description;
        string salary;
        string expirence;
        address[] applicants;
    }
  

    mapping (address => applicant_details) applicant;
    mapping (uint => job_details) job;
    mapping (uint => mapping(address => bool)) public hasApplied;
    

    modifier onlyAdmin(){
        require(admin == msg.sender, "Only Admin is allowed for this action");
        _;
    }

    modifier jobIdIsUnique(uint _id){
        require(!(bytes(job[_id].title).length > 0), "Job with similar ID already Exists");
        _;
    }

    modifier jobExists(uint _id){
        require(bytes(job[_id].title).length > 0, "No Such Job Exists");
        _;
    }
    

    //Add a new applicant
    function addApplicant(address _address, string memory _name,uint _phone, string memory _home_address, uint8 _age, string memory _skills, string memory _workExp, jobType _type)public onlyAdmin {
        applicant[_address] = applicant_details(_name, _phone, _home_address , _age, 0 ,_skills, _workExp, _type);
    }

    // Get applicant details 
    function fetchApplicant(address _address) public view returns(applicant_details memory) {
        return applicant[_address];
    }

    //Get applicant type
    function fetchApplicantType(address _address) public view returns(jobType) {
        return applicant[_address].job_preference;
    }

    //Add a new Job to the portal
    function addJob(uint _id, string memory _title, string memory _description, string memory _salary, string memory _expirence) public jobIdIsUnique(_id){
        job[_id] = job_details(_title, _description, _salary, _expirence, new address[](0));
    }

    //Get job details 
    function fetchJob(uint _id) public view returns(job_details memory) {
        return job[_id];
    }

    //Applicants apply for a job 
    function jobApply(uint _jobId) public jobExists(_jobId){
        require(bytes(applicant[msg.sender].name).length > 0, "Only Registered applicant can apply");
        require(!(hasApplied[_jobId][msg.sender]), "Already Applied");
        hasApplied[_jobId][msg.sender] = true;
        job[_jobId].applicants.push(msg.sender);
        
        // appliedJob[_jobId] = msg.sender;
    }

    //Provide a rating to an applicant 
    function addRating(address _applicantAddress, uint8 _rating) public {
        require(_rating >= 1 && _rating <= 5, "Rating must be between 1 and 5");
        applicant[_applicantAddress].rating = _rating;
    }

    //Fetch applicant rating 
    function fetchRating(address _applicantAddress) public view returns(uint8) {
        return applicant[_applicantAddress].rating;
    }
}

