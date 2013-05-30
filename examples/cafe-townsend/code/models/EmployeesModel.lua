require "vo.EmployeeVO"

EmployeesModel = {}

function EmployeesModel:new()
	local model = {}
	model.employees = nil

	function model:init()
		self.employees = {
	 		EmployeeVO:new({id=0,firstName="Tommy",lastName="Maintz",phoneNumber="508-566-6666" }),
            EmployeeVO:new({ id= 1,     firstName="Rob",  lastName="Dougan",phoneNumber="508-566-6666" }),
            EmployeeVO:new({ id= 2,     firstName="Ed",   lastName="Spencer",phoneNumber="508-566-6666" }),
            EmployeeVO:new({ id= 3,     firstName="Jamie",lastName="Avins", phoneNumber="508-566-6666" }),
            EmployeeVO:new({ id= 4,     firstName="Aaron",lastName="Conran",phoneNumber="508-566-6666" }),
            EmployeeVO:new({ id= 5,     firstName="Dave", lastName="Kaneda",phoneNumber="508-566-6666" }),
            EmployeeVO:new({ id= 6,     firstName="Jacky",lastName="Nguyen",phoneNumber="508-566-6666" }),
            EmployeeVO:new({ id= 7,     firstName="Abraham",lastName="Elias", phoneNumber="508-566-6666" }),
            EmployeeVO:new({ id= 8,     firstName="Jay",  lastName="Robinson",phoneNumber="508-566-6666" }),
            EmployeeVO:new({ id= 9,     firstName="Nigel",lastName="White", phoneNumber="508-566-6666" }),
            EmployeeVO:new({ id= 10,    firstName="Don",  lastName="Griffin",phoneNumber="508-566-6666" }),
            EmployeeVO:new({ id= 11,    firstName="Nico", lastName="Ferrero",phoneNumber="508-566-6666" }),
            EmployeeVO:new({ id= 12,   firstName= "Jason",lastName="Johnston",phoneNumber="508-566-6666" })
        }
	end

      function model:delete(employee)
            local index = table.indexOf(self.employees, employee)
            if index then
                  table.remove(self.employees, employee)
                  Runtime:dispatchEvent({name="EmployeesModel_onChanged", 
                                          target=self,
                                          index=index, 
                                          employee=employee,
                                          kind="remove"})
                  return true
            end
            return false
      end

      function model:save(employee)
            local index = table.indexOf(self.employees, employee)
            if index == nil then
                  table.insert(self.employees, employee)
                  Runtime:dispatchEvent({name="EmployeesModel_onChanged", 
                                          target=self,
                                          index=table.indexOf(self.employees, employee), 
                                          employee=employee,
                                          kind="add"})
                  return true
            end
            return false
      end

	model:init()

	return model
end

return EmployeesModel