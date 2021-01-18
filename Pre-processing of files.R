library(openxlsx)
library(dplyr)

# the first row contains info that's not part of data table
dt_raw_SFS <- openxlsx::read.xlsx('SFS_SISOne - Thematic Analysis Data_20200820.xlsx', sheet = 1, startRow = 2)


# write.csv(dt_raw, 'data/raw.csv',row.names = FALSE)

# remove redundant subject version column
##dt_raw_SFS <- dt_raw_SFS[,-39]



# SFS
# Q201 has 11994 answers less than 5 characters and 38 answers that does not contain any answer
# Q202 has 65362 answers with less than 5 characters and 59165 with no response
# Interestingly, a lot of those empty Q201 has comprehensive response on Q202
# Similarly, a good number of answers with empty Q202 has substantial and meaningful text in Q201
# Therefore, we should NOT filter out emptry Q201
# This also implies that we need to send Q201 and Q202 seperately to Azure since it cannot process 
# empty data and that will still account for a transaction and charge for it.

dim(dt_raw_SFS[is.na(dt_raw_SFS$Q201),]) # 52276    62
dim(dt_raw_SFS[nchar(dt_raw_SFS$Q201) < 5,]) # 65362    62
dim(dt_raw_SFS[is.na(dt_raw_SFS$Q202),]) # 59165    62
dim(dt_raw_SFS[nchar(dt_raw_SFS$Q202) < 5,]) # 54959    62
dim(dt_raw_SFS[is.na(dt_raw_SFS$Q203),]) # 59165    62
dim(dt_raw_SFS[nchar(dt_raw_SFS$Q203) < 5,]) # 54959    62
# SFT
##dim(dt_raw_SFT[nchar(dt_raw_SFT$`Q13_What.were.the.best.aspects.of.the.teaching.of.this.subject?.Please.limit.your.comments.to.issues.relating.to.teaching.and.learning..Any.comments.which.are.not.in.the.spirit.of.the.Student.Charter,.will.be.discarded.`) < 5,]) # 21256    72
##dim(dt_raw_SFT[nchar(dt_raw_SFT$`Q14_What.aspects.of.the.teaching.of.this.subject.were.most.in.need.of.improvement?.Please.limit.your.comments.to.issues.relating.to.teaching.and.learning..Any.comments.which.are.not.in.the.spirit.of.the.Student.Charter,.will.be.discarded.`) < 5,]) # 29643    72
##q41 = q13
##q51 = q14


# remove _x00D_ and x000D -> ordering is important to avoid having "_ _"
# Should not remove punctuation as they preserve sense
# dt_raw_SFS_cleaned$Q201 <- gsub("[[:punct:]]", "", dt_raw_SFS_cleaned$Q201)
dt_raw_SFS$Q201 <- gsub("_x000D_", " ", dt_raw_SFS$Q201)
dt_raw_SFS$Q201 <- gsub("x000D", " ", dt_raw_SFS$Q201)
dt_raw_SFS$Q202 <- gsub("_x000D_", " ", dt_raw_SFS$Q202)
dt_raw_SFS$Q202 <- gsub("x000D", " ", dt_raw_SFS$Q202)
dt_raw_SFS$Q203 <- gsub("_x000D_", " ", dt_raw_SFS$Q203)
dt_raw_SFS$Q203 <- gsub("x000D", " ", dt_raw_SFS$Q203)

dt_raw_SFS$Q201 <- gsub("\\bnil\\b", "", dt_raw_SFS$Q201)
dt_raw_SFS$Q201 <- gsub("\\bNIL\\b", "", dt_raw_SFS$Q201)
dt_raw_SFS$Q202 <- gsub("\\bnil\\b", "", dt_raw_SFS$Q202)
dt_raw_SFS$Q202 <- gsub("\\bNIL\\b", "", dt_raw_SFS$Q202)
dt_raw_SFS$Q203 <- gsub("\\bnil\\b", "", dt_raw_SFS$Q203)
dt_raw_SFS$Q203 <- gsub("\\bNIL\\b", "", dt_raw_SFS$Q203)

dt_raw_SFS$Q201 <- gsub("-", " ", dt_raw_SFS$Q201)
dt_raw_SFS$Q201 <- gsub("-", " ", dt_raw_SFS$Q201)
dt_raw_SFS$Q202 <- gsub("-", " ", dt_raw_SFS$Q202)
dt_raw_SFS$Q202 <- gsub("-", " ", dt_raw_SFS$Q202)
dt_raw_SFS$Q203 <- gsub("-", " ", dt_raw_SFS$Q203)
dt_raw_SFS$Q203 <- gsub("-", " ", dt_raw_SFS$Q203)

dt_raw_SFS$Q201 <- gsub("=", "", dt_raw_SFS$Q201)
dt_raw_SFS$Q201 <- gsub("=", "", dt_raw_SFS$Q201)
dt_raw_SFS$Q202 <- gsub("=", "", dt_raw_SFS$Q202)
dt_raw_SFS$Q202 <- gsub("=", "", dt_raw_SFS$Q202)
dt_raw_SFS$Q203 <- gsub("=", "", dt_raw_SFS$Q203)
dt_raw_SFS$Q203 <- gsub("=", "", dt_raw_SFS$Q203)

dt_raw_SFS$Q201 <- gsub("!", "", dt_raw_SFS$Q201)
dt_raw_SFS$Q201 <- gsub("!", "", dt_raw_SFS$Q201)
dt_raw_SFS$Q202 <- gsub("!", "", dt_raw_SFS$Q202)
dt_raw_SFS$Q202 <- gsub("!", "", dt_raw_SFS$Q202)
dt_raw_SFS$Q203 <- gsub("!", "", dt_raw_SFS$Q203)
dt_raw_SFS$Q203 <- gsub("!", "", dt_raw_SFS$Q203)

dt_raw_SFS$Q201 <- gsub("?", "", dt_raw_SFS$Q201)
dt_raw_SFS$Q201 <- gsub("?", "", dt_raw_SFS$Q201)
dt_raw_SFS$Q202 <- gsub("?", "", dt_raw_SFS$Q202)
dt_raw_SFS$Q202 <- gsub("?", "", dt_raw_SFS$Q202)
dt_raw_SFS$Q203 <- gsub("?", "", dt_raw_SFS$Q203)
dt_raw_SFS$Q203 <- gsub("?", "", dt_raw_SFS$Q203)


#dt_raw_SFT$Q41 <- gsub("_x000D_", " ", dt_raw_SFT$`Q13_What.were.the.best.aspects.of.the.teaching.of.this.subject?.Please.limit.your.comments.to.issues.relating.to.teaching.and.learning..Any.comments.which.are.not.in.the.spirit.of.the.Student.Charter,.will.be.discarded.`)
##dt_raw_SFT$Q41 <- gsub("x000D", " ", dt_raw_SFT$`Q13_What.were.the.best.aspects.of.the.teaching.of.this.subject?.Please.limit.your.comments.to.issues.relating.to.teaching.and.learning..Any.comments.which.are.not.in.the.spirit.of.the.Student.Charter,.will.be.discarded.`)
#dt_raw_SFT$Q51 <- gsub("_x000D_", " ", dt_raw_SFT$`Q14_What.aspects.of.the.teaching.of.this.subject.were.most.in.need.of.improvement?.Please.limit.your.comments.to.issues.relating.to.teaching.and.learning..Any.comments.which.are.not.in.the.spirit.of.the.Student.Charter,.will.be.discarded.`)
#dt_raw_SFT$Q51 <- gsub("x000D", " ", dt_raw_SFT$`Q14_What.aspects.of.the.teaching.of.this.subject.were.most.in.need.of.improvement?.Please.limit.your.comments.to.issues.relating.to.teaching.and.learning..Any.comments.which.are.not.in.the.spirit.of.the.Student.Charter,.will.be.discarded.`)
#dt_raw_SFT$Q41 <- gsub("\\bnil\\b", "", dt_raw_SFT$`Q13_What.were.the.best.aspects.of.the.teaching.of.this.subject?.Please.limit.your.comments.to.issues.relating.to.teaching.and.learning..Any.comments.which.are.not.in.the.spirit.of.the.Student.Charter,.will.be.discarded.`)
##dt_raw_SFT$Q41 <- gsub("\\bNIL\\b", "", dt_raw_SFT$`Q13_What.were.the.best.aspects.of.the.teaching.of.this.subject?.Please.limit.your.comments.to.issues.relating.to.teaching.and.learning..Any.comments.which.are.not.in.the.spirit.of.the.Student.Charter,.will.be.discarded.`)
##dt_raw_SFT$Q51 <- gsub("\\bnil\\b", "", dt_raw_SFT$`Q14_What.aspects.of.the.teaching.of.this.subject.were.most.in.need.of.improvement?.Please.limit.your.comments.to.issues.relating.to.teaching.and.learning..Any.comments.which.are.not.in.the.spirit.of.the.Student.Charter,.will.be.discarded.`)
##dt_raw_SFT$Q51 <- gsub("\\bNIL\\b", "", dt_raw_SFT$`Q14_What.aspects.of.the.teaching.of.this.subject.were.most.in.need.of.improvement?.Please.limit.your.comments.to.issues.relating.to.teaching.and.learning..Any.comments.which.are.not.in.the.spirit.of.the.Student.Charter,.will.be.discarded.`)
##dt_raw_SFT$Q41 <- gsub("-", " ", dt_raw_SFT$`Q13_What.were.the.best.aspects.of.the.teaching.of.this.subject?.Please.limit.your.comments.to.issues.relating.to.teaching.and.learning..Any.comments.which.are.not.in.the.spirit.of.the.Student.Charter,.will.be.discarded.`)
##dt_raw_SFT$Q41 <- gsub("-", " ", dt_raw_SFT$`Q13_What.were.the.best.aspects.of.the.teaching.of.this.subject?.Please.limit.your.comments.to.issues.relating.to.teaching.and.learning..Any.comments.which.are.not.in.the.spirit.of.the.Student.Charter,.will.be.discarded.`)
##dt_raw_SFT$Q51 <- gsub("-", " ", dt_raw_SFT$`Q14_What.aspects.of.the.teaching.of.this.subject.were.most.in.need.of.improvement?.Please.limit.your.comments.to.issues.relating.to.teaching.and.learning..Any.comments.which.are.not.in.the.spirit.of.the.Student.Charter,.will.be.discarded.`)
##dt_raw_SFT$Q51 <- gsub("-", " ", dt_raw_SFT$`Q14_What.aspects.of.the.teaching.of.this.subject.were.most.in.need.of.improvement?.Please.limit.your.comments.to.issues.relating.to.teaching.and.learning..Any.comments.which.are.not.in.the.spirit.of.the.Student.Charter,.will.be.discarded.`)
##dt_raw_SFT$Q41 <- gsub("=", "", dt_raw_SFT$`Q13_What.were.the.best.aspects.of.the.teaching.of.this.subject?.Please.limit.your.comments.to.issues.relating.to.teaching.and.learning..Any.comments.which.are.not.in.the.spirit.of.the.Student.Charter,.will.be.discarded.`)
##t_raw_SFT$Q41 <- gsub("=", "", dt_raw_SFT$`Q13_What.were.the.best.aspects.of.the.teaching.of.this.subject?.Please.limit.your.comments.to.issues.relating.to.teaching.and.learning..Any.comments.which.are.not.in.the.spirit.of.the.Student.Charter,.will.be.discarded.`)
##dt_raw_SFT$Q51 <- gsub("=", "", dt_raw_SFT$`Q14_What.aspects.of.the.teaching.of.this.subject.were.most.in.need.of.improvement?.Please.limit.your.comments.to.issues.relating.to.teaching.and.learning..Any.comments.which.are.not.in.the.spirit.of.the.Student.Charter,.will.be.discarded.`)
##dt_raw_SFT$Q51 <- gsub("=", "", dt_raw_SFT$`Q14_What.aspects.of.the.teaching.of.this.subject.were.most.in.need.of.improvement?.Please.limit.your.comments.to.issues.relating.to.teaching.and.learning..Any.comments.which.are.not.in.the.spirit.of.the.Student.Charter,.will.be.discarded.`)
###dt_raw_SFT$Q41 <- gsub("!", "", dt_raw_SFT$`Q13_What.were.the.best.aspects.of.the.teaching.of.this.subject?.Please.limit.your.comments.to.issues.relating.to.teaching.and.learning..Any.comments.which.are.not.in.the.spirit.of.the.Student.Charter,.will.be.discarded.`)
####dt_raw_SFT$Q41 <- gsub("!", "", dt_raw_SFT$`Q13_What.were.the.best.aspects.of.the.teaching.of.this.subject?.Please.limit.your.comments.to.issues.relating.to.teaching.and.learning..Any.comments.which.are.not.in.the.spirit.of.the.Student.Charter,.will.be.discarded.`)
##dt_raw_SFT$Q51 <- gsub("!", "", dt_raw_SFT$`Q14_What.aspects.of.the.teaching.of.this.subject.were.most.in.need.of.improvement?.Please.limit.your.comments.to.issues.relating.to.teaching.and.learning..Any.comments.which.are.not.in.the.spirit.of.the.Student.Charter,.will.be.discarded.`)
###dt_raw_SFT$Q51 <- gsub("!", "", dt_raw_SFT$`Q14_What.aspects.of.the.teaching.of.this.subject.were.most.in.need.of.improvement?.Please.limit.your.comments.to.issues.relating.to.teaching.and.learning..Any.comments.which.are.not.in.the.spirit.of.the.Student.Charter,.will.be.discarded.`)
##dt_raw_SFT$Q41 <- gsub("?", "", dt_raw_SFT$`Q13_What.were.the.best.aspects.of.the.teaching.of.this.subject?.Please.limit.your.comments.to.issues.relating.to.teaching.and.learning..Any.comments.which.are.not.in.the.spirit.of.the.Student.Charter,.will.be.discarded.`)
##dt_raw_SFT$Q41 <- gsub("?", "", dt_raw_SFT$`Q13_What.were.the.best.aspects.of.the.teaching.of.this.subject?.Please.limit.your.comments.to.issues.relating.to.teaching.and.learning..Any.comments.which.are.not.in.the.spirit.of.the.Student.Charter,.will.be.discarded.`)
##dt_raw_SFT$Q51 <- gsub("?", "", dt_raw_SFT$`Q14_What.aspects.of.the.teaching.of.this.subject.were.most.in.need.of.improvement?.Please.limit.your.comments.to.issues.relating.to.teaching.and.learning..Any.comments.which.are.not.in.the.spirit.of.the.Student.Charter,.will.be.discarded.`)
##dt_raw_SFT$Q51 <- gsub("?", "", dt_raw_SFT$`Q14_What.aspects.of.the.teaching.of.this.subject.were.most.in.need.of.improvement?.Please.limit.your.comments.to.issues.relating.to.teaching.and.learning..Any.comments.which.are.not.in.the.spirit.of.the.Student.Charter,.will.be.discarded.`)
##head(dt_raw_SFT$Q51)
# cleaning free text field
# removing answer like "Yes", "xx", "x", "YOLO"
# preserving answer like "None" and "Nothing" as they could contain crucial information
# Also preserving any records that may have less than 4 characters in either Q201 or Q202
# but more characters in at least one of them. This will keep reviews that could not find
# anything to mention in response of Q201 or Q202 but had longer response on at least one of them
dt_raw_SFS_cleaned <- dt_raw_SFS %>%
  filter(nchar(Q201) > 4 & nchar(Q202) > 4 & nchar(Q203) > 4)  


##FILTERING PART
## To filter just for 1 variable, in this case I have demonstrated the location
dt_raw_SFS_cleaned <- subset(dt_raw_SFS_cleaned, Location == "")
## TO filter for more than one
dt_raw_SFS_cleaned <- subset(dt_raw_SFS_cleaned, Location == "" & Course.Code == "")
##Important -> Do ensure that the Location and Course.Code are the column names. 
##Column names need to be written down correctly without spelling error

## Save the file 
write.csv(dt_raw_SFS_cleaned, file = "SFS_2020_cleaned.csv", row.names = FALSE)

# filter(nchar(Q201) < 4 & nchar(Q202) < 4)

##dt_raw_SFT_cleaned <- dt_raw_SFT %>%
  #filter(nchar(Q41) > 4 | nchar(Q51) > 4) 

##write.csv(dt_raw_SFT_cleaned, file = "SFT_2020_cleaned.csv", row.names = FALSE)

# not every student who is in SFS is in SFT
# SFS has  30276 unique student ID wheras SFT has just 13481
##common_student_id = intersect(dt_raw_SFS_cleaned$new.student.ID, dt_raw_SFT_cleaned$NewStudentID)

##write.xlsx(common_student_id, file = "common_student_id.xlsx")

