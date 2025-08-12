# Basic Calculator Program

# Create a simple Python program that asks the user to input two numbers and a mathematical operation (addition, subtraction, multiplication, or division).
# Perform the operation based on the user's input and print the result.

# Example If a user inputs 10, 5, and +, your program should display 10 + 5 = 15.

message = """
  1. Addition
  2. Substraction
  3. Multiplication
  4. Division
"""
print(message)
CHOICE = str(input("WHat do you want to do ( Select from the choie above eg( 1 for addion): "))
if CHOICE == "1" or CHOICE.lower() == "addition":
  first_number = int(input("Enter your first number: "))
  second_number = int(input("Enter your second number: "))
  print("Result:", first_number + second_number)

elif CHOICE == "2" or CHOICE.lower() == "substraction":
  first_number = int(input("Enter your first number: "))
  second_number = int(input("Enter your second number: "))
  print("Result:", first_number - second_number)

elif CHOICE == "3" or CHOICE.lower() == "multiplication":
  first_number = int(input("Enter your first number: "))
  second_number = int(input("Enter your second number: "))
  print("Result:", first_number * second_number)

elif CHOICE == "4" or CHOICE.lower() == "division":
  first_number = int(input("Enter your first number: "))
  second_number = int(input("Enter your second number: "))
  print("Result:", first_number / second_number)

else:
  print("Please select any of the choices above")


