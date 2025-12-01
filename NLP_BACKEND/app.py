import os
from flask import Flask, request, jsonify
from sentiment_engine import recommend_products, generate_explanation

app = Flask(__name__)


@app.route("/recommend", methods=["POST"])
def recommend():
    try:
        # 1. Receive data from Flutter (e.g., {"hair_type": "Curly", "confidence": 99.9})
        data = request.get_json()

        if not data or "hair_type" not in data:
            return jsonify({"error": "No hair_type provided"}), 400

        hair_type = data["hair_type"]
        # Confidence is optional, default to 0.0 if missing
        confidence = float(data.get("confidence", 0.0))

        # 2. Ask the Sentiment Engine for products
        recommendations = recommend_products(hair_type)

        # 3. Generate the explanation text
        explanation = generate_explanation(hair_type, confidence, recommendations)

        # 4. Send back to Flutter
        return jsonify(
            {
                "status": "success",
                "hair_type": hair_type,
                "explanation": explanation,
                "recommendations": recommendations,
            }
        )

    except Exception as e:
        print(f"Error in /recommend: {e}")
        return jsonify({"error": str(e)}), 500


if __name__ == "__main__":
    # Host 0.0.0.0 allows your emulator/phone to connect
    app.run(host="0.0.0.0", port=5000, debug=True)