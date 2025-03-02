func isSameDisplay(displayOne: DisplayInfo, displayTwo: DisplayInfo) -> Bool {
	return displayOne.localizedName == displayTwo.localizedName
		&& displayOne.frame.width == displayTwo.frame.width
		&& displayOne.frame.height == displayTwo.frame.height
}
