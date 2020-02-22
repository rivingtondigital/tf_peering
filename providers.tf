# providers.tf

provider "aws" {
	region	= var.regionA
	alias		= "A"
}

provider "aws" {
	region	= var.regionB
	alias		= "B"
}

