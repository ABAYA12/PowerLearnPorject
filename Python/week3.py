# Create a function named calculate_discount(price, discount_percent) that calculates the final price after applying a discount. 
# The function should take the original price (price) and the discount percentage (discount_percent) as parameters.
# If the discount is 20% or higher, apply the discount; otherwise, return the original price.
# Using the calculate_discount function, prompt the user to enter the original price of an item and the discount percentage.
# Print the final price after applying the discount, or if no discount was applied, print the original price.


def calculate_discount(price, discount_percent):
  if (discount_percent / 100) >= 0.2:
    discount_amount = price * (discount_percent / 100)
    final_price = price - discount_amount
    print(f"Final price after discount: {final_price}")
  else:
    print("Discount percentage is too low, no discount applied.")
    print(f"Final price: {price}")

price = int(input("Enter Price of the item: "))
discount = int(input("Enter discount percentage: "))

calculate_discount(price, discount)
