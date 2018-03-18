plot2 <- function() {

	myurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip";
	myfile1 <- "data/household_power_consumption.zip"
	myfile2 <- "household_power_consumption.txt"					# filename within zip file
	myfile3 <- "data/household_power_consumption_extract.txt"		# dataset extract for dates 2007-02-01 and 2007-02-02
	export_filename <- "plot2.png"

	library ("data.table")

	if (!file.exists("data")) {
		dir.create("data")
	}
	if (!file.exists(myfile1)) {
		download.file(myurl, destfile=myfile1)
		dataDownLoaded <- date()
		print ("Data downloaded and stored in data directory")
	}

	# extract and save our two days of required data (2007-02-01 and 2007-02-02) in case not already extracted in order to speed up further analysis
	if (!file.exists(myfile3)) {
		# read all data from original zipped csv file and put into data table:
		DT <- data.table(read.table(unz(myfile1, myfile2), sep=";", header=TRUE, as.is=TRUE, na.strings="?"))
		DT$Date <- as.Date(strptime(DT$Date, "%d/%m/%Y"))
		DT2 <- DT[Date == "2007-02-01" | Date == "2007-02-02"]
		# store subset DT for required dates in myfile3 txt file
		write.table(DT2, myfile3, col.names=TRUE)
	}

	# open data extract for the two required dates
	DT <- data.table(read.table(myfile3, as.is=TRUE, na.strings="?"))

	# combine date and time columns into a new column with type POSIXct
	DT$Date2 <- paste(DT$Date, DT$Time)
	DT$Date2 <- as.POSIXct(strptime(DT$Date2, "%Y-%m-%d %H:%M:%S"))
	
	# create line plot:
	par(bg = "white")
	plot(DT$Global_active_power ~ DT$Date2, type = "l", main="", xlab="", ylab="Global Active Power (kilowatts)")

	# store plot as PNG file
	dev.copy(png, export_filename, width = 480, height = 480)
	dev.off()
	
}