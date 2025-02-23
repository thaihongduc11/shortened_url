# URL Shortener API Documentation

## Encode URL

### Endpoint
**URL:** `https://shortened-url-huc3.onrender.com/api/v1/encode`  
**Method:** `POST`  

### Request Parameters
**Content-Type:** `application/json`

#### Body Parameters:
| Parameter | Type   | Required | Description                   |
|-----------|--------|----------|-------------------------------|
| `url`     | string | Yes      | The original URL to be shortened |

#### Example Request
```json
{
    "url": "https://stackoverflow.com/"
}
```

---

### Responses

#### **Example Success Response (200)**
**Description:** The URL is successfully encoded.

```json
{
    "message": "Encode URL successfully",
    "content": {
        "short_url": "http://shortened-url-huc3.onrender.com/YMIQgu"
    }
}
```

#### **Example Error Response (400)**
**Description:** The URL encoding failed due to an invalid URL.

```json
{
    "message": "Failed to encode URL",
    "content": {
        "errors": [
            {
                "message": "Invalid URL"
            }
        ],
        "status": 400
    }
}
```

## Decode URL

### Endpoint
**URL:** `https://shortened-url-huc3.onrender.com/api/v1/decode`  
**Method:** `POST`

### Request Parameters
**Content-Type:** `application/json`

#### Body Parameters:
| Parameter | Type   | Required | Description                   |
|-----------|--------|----------|-------------------------------|
| `url`     | string | Yes      | The short URL                 |

#### Example Request
```json
{
    "url": "https://stackoverflow.com/"
}
```

---

### Responses

#### **Example Success Response (200)**
**Description:** The URL is successfully decoded.

```json
{
    "message": "Decode URL successfully",
    "content": {
        "short_url": "http://shortened-url-huc3.onrender.com/YMIQgu"
    }
}
```

#### **Example Error Response (400)**
**Description:** The URL decoding failed due to an invalid URL.

```json
{
    "message": "Failed to decode URL",
    "content": {
        "errors": [
            {
                "message": "Invalid URL"
            }
        ],
        "status": 400
    }
}
```

