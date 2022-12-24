USE BUDT703_Project_0506_10
--Drop Tables


DROP TABLE IF EXISTS [PerfectAnalyst.Apply] ;
DROP TABLE IF EXISTS [PerfectAnalyst.Check] ;
DROP TABLE IF EXISTS [PerfectAnalyst.Require] ;
DROP TABLE IF EXISTS [PerfectAnalyst.Has] ;
DROP TABLE IF EXISTS [PerfectAnalyst.ProfileMatch] ;
DROP TABLE IF EXISTS [PerfectAnalyst.Skill] ;
DROP TABLE IF EXISTS [PerfectAnalyst.Rating] ;
DROP TABLE IF EXISTS [PerfectAnalyst.Job] ;
DROP TABLE IF EXISTS [PerfectAnalyst.Company] ;
DROP TABLE IF EXISTS [PerfectAnalyst.JobSeekerPreviousExperience] ;
DROP TABLE IF EXISTS [PerfectAnalyst.JobSeekerEducation] ;
DROP TABLE IF EXISTS [PerfectAnalyst.JobSeeker] ;


--SQL Create Tables 



---Job Seeker Table
CREATE TABLE [PerfectAnalyst.JobSeeker](
	jbsId CHAR(5) NOT NULL,
	jbsFirstName VARCHAR(20),
	jbsLastName VARCHAR(20),	
	jbsBirthDate DATE,
	jbsEmailId VARCHAR(30),
	jbsPhnNum VARCHAR(12),
	jbsCity VARCHAR(20),
	jbsState VARCHAR(10),
	jbsZipCode CHAR(5)
	CONSTRAINT pk_JobSeeker_jbsId PRIMARY KEY (jbsId))

---Job Seeker Education Table
CREATE TABLE [PerfectAnalyst.JobSeekerEducation](
	jbsId CHAR(5) NOT NULL,
	jbsEducation VARCHAR(20) NOT NULL,
	CONSTRAINT pk_JobSeekerEducation_jbsId_jbsEducation PRIMARY KEY (jbsId, jbsEducation),
	CONSTRAINT fk_JobSeekerEducation_jbsId FOREIGN KEY (jbsId)
		REFERENCES [PerfectAnalyst.JobSeeker](jbsId)
		ON DELETE NO ACTION ON UPDATE CASCADE)

--Job Seeker Previous Experience Table
CREATE TABLE [PerfectAnalyst.JobSeekerPreviousExperience](
	jbsId CHAR(5) NOT NULL,
	jbsPrevExperience VARCHAR(60) NOT NULL,
	CONSTRAINT pk_JobSeekerPreviousExperience_jbsId_jbsPrevExperience 
	PRIMARY KEY (jbsId, jbsPrevExperience),
	CONSTRAINT fk_JobSeekerPreviousExperience_jbsId FOREIGN KEY (jbsId)
		REFERENCES [PerfectAnalyst.JobSeeker](jbsId)
		ON DELETE NO ACTION ON UPDATE CASCADE)	

---Company Table
CREATE TABLE[PerfectAnalyst.Company](
	compId CHAR(5) NOT NULL,
	compName VARCHAR(60),
	compDesc VARCHAR(60),
	compCity VARCHAR(20),
	compState CHAR(2),
	compSize VARCHAR(30)
	CONSTRAINT pk_Company_compId PRIMARY KEY(compId))

---Job Table
CREATE TABLE[PerfectAnalyst.Job](
	jobId CHAR(5) NOT NULL,
	jobFunction VARCHAR(25),
	jobDesc VARCHAR(200),
	[jobSalary (in $ per year)] INTEGER,
	jobType VARCHAR(10),
	jobLocation VARCHAR(20),
	compId CHAR(5),
	CONSTRAINT pk_Job_jobId PRIMARY KEY(jobId),
	CONSTRAINT fk_Job_compId FOREIGN KEY(compId)
		REFERENCES [PerfectAnalyst.Company](compId)
	    ON DELETE NO ACTION ON UPDATE NO ACTION)

---Rating Table
CREATE TABLE[PerfectAnalyst.Rating](
	ratId CHAR(5) NOT NULL,
	ratCultureValue DECIMAL(2,1),
	ratWorkLifeBalance DECIMAL(2,1),
	ratSeniorManagement DECIMAL(2,1),
	ratCompBenefits DECIMAL(2,1),
	ratCareerOpportunities DECIMAL(2,1),
	ratOverallRating DECIMAL(2,1),
	ratSiteSource VARCHAR(10),
	compId CHAR(5) NOT NULL,
	CONSTRAINT pk_Rating_ratId PRIMARY KEY(ratId),
	CONSTRAINT fk_Rating_compId FOREIGN KEY(compId)
		REFERENCES [PerfectAnalyst.Company](compId)
	    ON DELETE CASCADE ON UPDATE CASCADE)

---Skill Table
CREATE TABLE[PerfectAnalyst.Skill](
	sklId CHAR(5) NOT NULL,
	sklName VARCHAR(50),
	CONSTRAINT pk_Skill_sklId PRIMARY KEY(sklId))

---Profile Match Table
CREATE TABLE[PerfectAnalyst.ProfileMatch](
	pmId CHAR(5) NOT NULL,
	[pmScore(%)] INTEGER,
	pmCategory VARCHAR(10),
	[pmSkillMatch(%)] INTEGER,
	pmNumofAlumni INTEGER,
	CONSTRAINT pk_ProfileMatch_pmId PRIMARY KEY (pmId))

---Has Table
CREATE TABLE[PerfectAnalyst.Has](
	jbsId CHAR (5) NOT NULL,
	sklId CHAR (5) NOT NULL
    CONSTRAINT pk_Has_jbsId_sklId PRIMARY KEY (jbsId, sklId),
    CONSTRAINT fk_Has_jbsId FOREIGN KEY (jbsId)
		REFERENCES [PerfectAnalyst.JobSeeker] (jbsId)
        ON DELETE NO ACTION ON UPDATE CASCADE,
	CONSTRAINT fk_Has_sklId FOREIGN KEY (sklId)
        REFERENCES [PerfectAnalyst.Skill] (sklId)
        ON DELETE NO ACTION ON UPDATE CASCADE)

---Require Table
CREATE TABLE[PerfectAnalyst.Require](
	jbsId CHAR (5) NOT NULL,
	jobId CHAR (5) NOT NULL,
	sklId CHAR (5) NOT NULL
    CONSTRAINT pk_Require_jbsId_jobId_sklId PRIMARY KEY (jbsId, jobId, sklId),
    CONSTRAINT fk_Require_jbsId FOREIGN KEY (jbsId)
		REFERENCES [PerfectAnalyst.JobSeeker] (jbsId)
        ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT fk_Require_jobId FOREIGN KEY (jobId)
		REFERENCES [PerfectAnalyst.Job] (jobId)
        ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_Require_sklId FOREIGN KEY (sklId)
        REFERENCES [PerfectAnalyst.Skill] (sklId)
        ON DELETE CASCADE ON UPDATE CASCADE)

---Check Table
CREATE TABLE[PerfectAnalyst.Check](
    pmId CHAR (5) NOT NULL,
	jbsId CHAR (5) NOT NULL,
	jobId CHAR (5) NOT NULL
    CONSTRAINT pk_Check_pmId PRIMARY KEY (pmId),
    CONSTRAINT fk_Check_jbsId FOREIGN KEY (jbsId)
		REFERENCES [PerfectAnalyst.JobSeeker] (jbsId)
		ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT fk_Check_jobId FOREIGN KEY (jobId)
        REFERENCES [PerfectAnalyst.Job] (jobId)
        ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_Check_pmId FOREIGN KEY (pmId)
        REFERENCES [PerfectAnalyst.ProfileMatch] (pmId)
        ON DELETE CASCADE ON UPDATE CASCADE)

---Apply Table
CREATE TABLE[PerfectAnalyst.Apply](
	jbsId CHAR (5) NOT NULL,	
	jobId CHAR (5) NOT NULL,
	compId CHAR (5) NOT NULL,
	appDate DATE,
	appStatus VARCHAR(20)
    CONSTRAINT pk_Apply_jbsId_jobId PRIMARY KEY (jbsId, jobId),
    CONSTRAINT fk_Apply_jbsId FOREIGN KEY (jbsId)
		REFERENCES [PerfectAnalyst.JobSeeker] (jbsId)
        ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT fk_Apply_jobId FOREIGN KEY (jobId)
        REFERENCES [PerfectAnalyst.Job] (jobId)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_Apply_compId FOREIGN KEY (compId)
        REFERENCES [PerfectAnalyst.Company] (compId)
        ON DELETE CASCADE ON UPDATE CASCADE)
