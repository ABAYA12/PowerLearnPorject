# Smartphone class
class Smartphone:
    def __init__(self, brand, model, price):
        self.brand = brand
        self.model = model
        self.__price = price  # private attribute (encapsulation)

    def call(self, number):
        print(f"Calling {number} from {self.brand} {self.model}...")

    def get_price(self):
        return self.__price

    def set_price(self, new_price):
        if new_price > 0:
            self.__price = new_price
        else:
            print("Price must be positive!")

# Inherited Class
class AdvancedSmartphone(Smartphone):
    def __init__(self, brand, model, price, camera_megapixels):
        super().__init__(brand, model, price)  # call parent constructor
        self.camera_megapixels = camera_megapixels

    def take_photo(self):
        print(f"Taking a {self.camera_megapixels}MP photo!")

# Create objects
phone1 = Smartphone("Samsung", "Galaxy S23", 900)
phone2 = AdvancedSmartphone("Apple", "iPhone 14", 1200, 48)

# Test methods
phone1.call("123-456-789")
print("Price:", phone1.get_price())

phone2.call("987-654-321")
phone2.take_photo()
phone2.set_price(1100)
print("New Price:", phone2.get_price())



class Car:
    def move(self):
        print("Driving on the road...")

class Plane:
    def move(self):
        print("✈Flying in the sky...")

class Boat:
    def move(self):
        print("Sailing on the water...")

# List of vehicles
vehicles = [Car(), Plane(), Boat()]

# Polymorphism in action
for vehicle in vehicles:
    vehicle.move()
