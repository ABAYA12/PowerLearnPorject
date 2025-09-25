# Step 1. Chatbot Personality
bot_name = "CryptoBuddy"
tone = "Friendly & supportive. Always here to help you pick greener cryptos!"

print(f"{bot_name}: Hey there! {tone}\n")

crypto_db = {
    "Bitcoin": {
        "price_trend": "rising",
        "market_cap": "high",
        "energy_use": "high",
        "sustainability_score": 3
    },
    "Ethereum": {
        "price_trend": "stable",
        "market_cap": "high",
        "energy_use": "medium",
        "sustainability_score": 6
    },
    "Cardano": {
        "price_trend": "rising",
        "market_cap": "medium",
        "energy_use": "low",
        "sustainability_score": 8
    },
    "Solana": {
        "price_trend": "volatile",
        "market_cap": "medium",
        "energy_use": "low",
        "sustainability_score": 7
    },
    "Ripple": {
        "price_trend": "stable",
        "market_cap": "medium",
        "energy_use": "low",
        "sustainability_score": 9
    }
}

# Step 3. Chatbot Logic
def chatbot_response(user_query):
    query = user_query.lower()

    if "sustainable" in query:
        recommend = max(crypto_db, key=lambda x: crypto_db[x]["sustainability_score"])
        return f"Invest in {recommend}! It’s eco-friendly and has long-term potential."

    elif "trending" in query or "up" in query:
        trending = [c for c, data in crypto_db.items() if data["price_trend"] == "rising"]
        return f"These cryptos are trending up : {', '.join(trending)}"

    elif "long-term" in query or "growth" in query:
        # Rule: rising trend + high market cap
        candidates = [c for c, d in crypto_db.items()
                      if d["price_trend"] == "rising" and d["market_cap"] == "high"]
        if candidates:
            return f"For long-term growth, check out: {', '.join(candidates)}"
        else:
            return "Hmm, none perfectly match long-term growth right now."

    elif "energy" in query or "eco" in query:
        low_energy = [c for c, d in crypto_db.items() if d["energy_use"] == "low"]
        return f"Low energy-use cryptos : {', '.join(low_energy)}"

    else:
        return "I’m not sure about that. Try asking about sustainability, trending, or long-term growth!"

while True:
    user = input("You: ")
    if user.lower() in ["quit", "exit", "bye"]:
        print(f"{bot_name}: Goodbye! Stay green")
        break
    print(f"{bot_name}: {chatbot_response(user)}")
