# Download the zipped dataset if it doesn't already exist
if (!file.exists("./household_power_consumption.txt")) {
  url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(url, destfile = "hpc.zip", method = "curl")
  
  # Extract it
  unzip("hpc.zip")
}

# Try to read it in
print("We've got the data, let's read it in and clean in...")
data <- read.table("household_power_consumption.txt", header = TRUE, sep = ";", 
                   na.strings = "?", nrows = 69600, stringsAsFactors = FALSE)

# Clean up the date and time formats
data$Date <- as.Date(data$Date, format = "%d/%m/%Y")
data$Time <- strftime(strptime(data$Time, format="%T"), "%T")
data$DateTime <- as.POSIXct(paste(data$Date, data$Time), format="%Y-%m-%d %H:%M:%S")

# Trim to the rows we need
data <- data[data$Date >= "2007-02-01" & data$Date <= "2007-02-02",]

# Plot 2, line plot of Global Active Power over time
png(filename = "plot2.png", width = 480, height = 480)
plot(data$DateTime, data$Global_active_power, type = "l", 
     ylab = "Global Active Power (kilowatts)", xlab = "")
dev.off()

print("plot 2 saved")