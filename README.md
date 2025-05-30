# gene-list
BED file creation from a gene list derived from the UCSC table browser

1. get unique list of gene names. 
 	Go to the excel file and copy/paste the gene names from the column
 	sort and unique to double check it is unique. 
 	put into a text file. 
 2. Put into UCSC Genome Table Browser to get locations 
 	Go to Tools 
 	Go to Table Browser 
 	Select NCBI Refseq for the track 
 	Under Define region of interest
 	Select genome
 	Select "upload list" next to identifiers (under Define region of interest). 
 	For output choose the dropdown and choose "selected fields from primary and related tables" 
 	Click Get output
 	Select name chrom strand txstart txend and Name2 
 	Click Get Output 
 	Should get a list of the genes with the information selected, the transcript and the "human readable" name (Name2). 
 	Copy paste to a text file. 
 	REMOVE ANY CHROMOSOMES THAT SAY "FIX" FROM THE FILE BEFORE PROCEEDING. 
 	
 	grep -v fix 1-12-22_gene-list-myeloid-somatic.txt > nofix_1-12-22_gene-list-myeloid-somatic.txt 

 	
 3. using the file of unique gene names and the file output from UCSC, run this program 
 	
 	perl refseq-composite-gene-size-across-transcripts.pl -UniqGene genelist-myeloid_1-12-22.txt -ucsc nofix_1-12-22_gene-list-myeloid-somatic.txt > outfile.txt
 	 
It will make a composite reference sequence combining the lowest start and highest stop in the UCSC file and it will combine all the transcript names into one long name. 

Double check you have 113 lines, the same number of lines as the unique gene name file 
 	
 4. Go to the Excel file, select the cell next to the end of the first line on the right side (ABL1 here). 
 Choose Data at the top, then Get External data, and select the outfile.txt file 
 to open, choose Delimited and select tab delimited. 
 It should import all the data in the rows to the excel file. 
 
 Check that there are the exact same lines in the outfile.txt import as the excel file. 
 Check that gene names match on each row 
 
 5. CLEAN CARRIAGE RETURNS FROM THE EXCEL FILE. 
Select any column with carriage returns, make a blank column next to it and use the formula 
 =SUBSTITUTE(G5,CHAR(13),"\."). Copy this formula down the rows. 
 When the column shows substituted carriage return for periods, then select the new column and choose copy and go to Edit, go to "paste special" and choose value  
This will create a column where the carriage returns are changed into periods. 
Delete the columns with carriage returns. 

Columns G, H, and I need carriage returns stripped. 

Select the cells with text and COPY PASTE this file to Text Wrangler -- a plain text file. Give the file a name. 


6. Run this program to make the bed file. This program can include more or less columns as wanted and will separate columns with a star 

perl make-bed.pl < nocarriage-file.txt > myeloid-genelist_11-5-21.bed

Commands Run:  
perl refseq-composite-gene-size-across-transcripts.pl -UniqGene genelist-uniq.txt -ucsc gene-list-myeloid-somatic.txt -header YES 

perl make-bed.pl < merged-myeloid.txt 

perl make-bed.pl < merged-myeloid.txt > gene-list-myeloid-somatic.txt

grep -v fix gene-list-myeloid-somatic.txt > nofix-gene-list-myeloid-somatic.txt

perl refseq-composite-gene-size-across-transcripts.pl -UniqGene genelist-uniq.txt -ucsc nofix-gene-list-myeloid-somatic.txt -header YES > outputgenelist.txt

perl make-bed.pl < myeloid-gene-v3-noreturn.txt > Final-Myeloid-Genes-V3.bed



