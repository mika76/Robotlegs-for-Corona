require "components.AutoSizeText"
require "components.Picture"
require "components.InputText"
require "components.DeleteButton"
require "components.BackButton"
require "components.HoverMenu"

EditEmployeeView = {}

function EditEmployeeView:new(parentGroup)
	local view = display.newGroup()
	view.classType = "EditEmployeeView"
	view.employee = nil
	view.photo = nil

	if parentGroup then
		parentGroup:insert(view)
	end

	function view:init()
		local header = display.newImage(self, "assets/images/phone/header.png", 0, 0, true)
		header:setReferencePoint(display.TopLeftReferencePoint)
		self.header = header

		local headerLabel = AutoSizeText:new(self)
		self.headerLabel = headerLabel
		headerLabel:setAutoSize(true)
		headerLabel:setFontSize(31)
		headerLabel:setTextColor(255, 255, 255)
		headerLabel:setFont(self.FONT_NAME)

		local picture = Picture:new(self)
		self.picture = picture
		picture:addEventListener("onAddTouched", self)

		local form = display.newImage(self, "assets/images/phone/employee-form-background.png")
		form:setReferencePoint(display.TopLeftReferencePoint)
		self.form = form

		local totalWidth = picture.width + 16 + form.width
		picture.x = (stage.width - totalWidth) / 2
		picture.y = header.y + header.height + 32
		form.x = picture.x + picture.width + 16
		form.y = picture.y

		local firstInput = InputText:new(self, form.width - 8, 30, "First Name")
		self.firstInput = firstInput
		firstInput:move(form.x + 8, form.y + 4)

		local lastInput = InputText:new(self, form.width - 8, 30, "Last Name")
		self.lastInput = lastInput
		lastInput:move(firstInput.x, firstInput.y + 43)

		local phoneInput = InputText:new(self, form.width - 8, 30, "Phone")
		self.phoneInput = phoneInput
		phoneInput:move(lastInput.x, lastInput.y + 44)

		local deleteButton = DeleteButton:new(self, totalWidth, 67)
		self.deleteButton = deleteButton
		deleteButton:addEventListener("onDeleteButtonTouched", self)
		deleteButton.x = picture.x
		deleteButton.y = form.y + form.height + 32
		deleteButton:setLabel("Delete Employee")

		local backButton = BackButton:new(self)
		backButton:addEventListener("onBackButtonTouched", self)
		self.backButton = backButton
		backButton.x = 6
		backButton.y = 6

		local saveButton = PushButton:new(self, 140, 67)
		self.saveButton = saveButton
		saveButton.x = stage.width - saveButton.width - 6
		saveButton.y = 0
		saveButton:setLabel("Save")
		saveButton:addEventListener("onPushButtonTouched", self)

		Runtime:dispatchEvent({name="onRobotlegsViewCreated", target=self})

	end

	function view:onDeleteButtonTouched()
		if self.employee == nil then return false end
		local employeeName = self.employee:getDisplayName()
		native.showAlert("Delete Employee",
							"Are you sure you wish to delete employee '" .. employeeName .. "'?",
							{"Delete Employee", "Cancel"}, self)
		
	end

	function view:completion(event)
		if event.action == "clicked" and event.index == 1 then
			self:dispatchEvent({name="onDeleteEmployee"})
		end
	end

	function view:onBackButtonTouched(event)
		self:dispatchEvent({name="onBackButtonTouched"})
	end

	function view:onPushButtonTouched(event)
		self:dispatchEvent({name="onSaveEmployee"})
	end

	function view:resize()
		local headerLabel = self.headerLabel
		local header = self.header
		-- ghetto measurement in full effect
		headerLabel.x = stage.width / 2 - headerLabel.width / 2
		headerLabel.y = header.y + header.height / 2 - headerLabel.height / 2
	end

	function view:setEmployee(employee)
		self.employee = employee
		self.headerLabel:setText(employee:getDisplayName())
		self.firstInput:setText(employee.firstName)
		self.lastInput:setText(employee.lastName)
		self.phoneInput:setText(employee.phoneNumber)
		self:resize()
	end

	function view:onAddTouched()

		 -- media.show(media.PhotoLibrary,
		 --        {listener=self, 
		 --        origin = self.picture.contentBounds, 
		 --        permittedArrowDirections = { "up", "right" } },
		 --        {baseDir=system.TemporaryDirectory, filename="image.jpg", type="image"} )

		if media.hasSource( media.Camera ) then
			if self.menu == nil then
				local picture = self.picture
				local menu = HoverMenu:new(self, {"Choose Existing Photo", "New Photo"})
				menu:addEventListener("onMenuButtonTouched", self)
				self.menu = menu
				menu.x = picture.x + picture.width / 2 - menu.width / 2
				menu.y = picture.y + picture.height - 8
				if menu.x < 0 then
					menu.x = 0
				end
			else
				self.menu:removeSelf()
				self.menu = nil
			end
		else
			self:chooseExistingPhoto()
		end

		-- local function onComplete(event)
		--    local photo = event.target
		--    view.photo = photo
		   
		--    local picture = self.picture
		--    photo.width = picture.width
		--    photo.height = picture.height
		--    photo.x = picture.x + photo.width / 2
		--    photo.y = picture.y + photo.height / 2
		--    -- local mask = graphics.newMask("assets/images/phone/photo-mask.png")
		--    -- photo:setMask(mask)
		--    -- photo.maskX = -4
		--    -- photo.maskY = -4
		-- end

		-- if media.hasSource( media.Camera ) then
		--    media.show( media.Camera, onComplete )
		-- else
		--    native.showAlert( "Corona", "This device does not have a camera.", { "OK" } )
		-- end

		-- local function onComplete(event)
		--    local photo = event.target

		--    print( "onComplete called ..." )

		--    if photo then
		--        print( "photo w,h = " .. photo.width .. "," .. photo.height )
		--     end
		-- end

		-- local button = display.newRect(120,240,80,70)

		-- -- Button tap listener
		-- local function pickPhoto( event )

		--     -- Note: Only use one of the media.show routines listed below

		--     -- Save photo to file in Temporary directory
		--     media.show( media.PhotoLibrary,
		--         {listener = onComplete, origin = button.contentBounds, permittedArrowDirections = { "right" } },
		--         {baseDir=system.TemporaryDirectory, filename="image.jpg", type="image"} )

		--     -- Show photo on screen (no file save)  
		--     media.show( media.PhotoLibrary,
		--         {listener = onComplete, origin = button.contentBounds, permittedArrowDirections = { "right" } } )
		-- end

		-- button:addEventListener("tap", pickPhoto )

	end

	function view:onMenuButtonTouched(event)
		self.menu:removeSelf()
		self.menu = nil
		local l = event.label
		if l == "Choose Existing Photo" then
			self:chooseExistingPhoto()
		else
			self:takeNewPhoto()
		end
	end

	function view:chooseExistingPhoto()
		 media.show(media.PhotoLibrary,
		        {listener=self, 
		        origin = self.picture.contentBounds, 
		        permittedArrowDirections = { "up", "right" } },
		        {baseDir=system.TemporaryDirectory, filename="image.jpg", type="image"} )

	end

	function view:takeNewPhoto()
		if media.hasSource( media.Camera ) then
		   media.show( media.Camera, self)
		else
		   native.showAlert( "Corona", "This device does not have a camera.", { "OK" } )
		end
	end

	function view:completion(event)
		if self.loadedImage then
			self.loadedImage:removeSelf()
		end

		if event.target == nil then
			print("loading local")
			self.loadedImage = display.newImage(self, "image.jpg", system.TemporaryDirectory)
			showProps(self.loadedImage)
		else
			print("using event")
			self.loadedImage = event.target
			display.save(self.loadedImage, "image.jpg")
		end
		self:sizePhoto()
	end

	function view:sizePhoto()
	  local picture = self.picture
	  local photo = self.loadedImage
	   photo.width = picture.width
	   photo.height = picture.height
	   photo.x = picture.x + photo.width / 2
	   photo.y = picture.y + photo.height / 2
	   -- local mask = graphics.newMask("assets/images/phone/photo-mask.png")
	   -- photo:setMask(mask)
	   -- photo.maskX = -4
	   -- photo.maskY = -4
	end


	view:init()

	return view
end

return EditEmployeeView