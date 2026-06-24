# 🎀 Pookie Hampers - E-Commerce Platform

The cutest gifts for your favorite pookies! A beautiful, fully responsive e-commerce platform for customizable hamper gifts.

## 📁 Project Structure

```
pookie-hampers/
├── index-formatted.html          # Home page
├── gift-formatted.html           # Gift customizer
├── about-formatted.html          # About page
├── policy-formatted.html         # Terms & policies
├── package.json                  # Project dependencies
├── tailwind.config.js            # Tailwind CSS configuration
├── config.json                   # App configuration
├── .env.example                  # Environment variables template
├── README.md                     # This file
│
└── src/
    ├── css/                      # Stylesheets
    │   ├── input.css            # Source CSS
    │   └── output.css           # Compiled CSS
    │
    ├── js/                       # JavaScript modules
    │   ├── cart.js              # Shopping cart logic
    │   ├── customizer.js        # Hamper customizer
    │   └── api.js               # API client
    │
    ├── images/                   # Image assets
    │   ├── logo.svg
    │   ├── hamper-*.jpg
    │   ├── product-*.jpg
    │   └── ...
    │
    └── data/
        └── products.json         # Product database
```

## 🚀 Quick Start

### Installation

```bash
npm install
```

### Development

```bash
npm run dev
# Opens on http://localhost:8000
```

### Build

```bash
npm run build
# Generates optimized CSS
```

### Watch Mode

```bash
npm run watch
# Auto-compiles CSS on file changes
```

## 🎨 Design System

**Color Palette:**
- Primary: `#81515b` (Dusty Rose)
- Secondary: `#5c5d6e` (Slate)
- Accent: `#ffc1cc` (Soft Pink)
- Background: `#fff8f8` (Off-White)

**Typography:**
- Headlines: Plus Jakarta Sans (600-800 weight)
- Body: Outfit (300-600 weight)
- Labels: Quicksand (500-700 weight)

**Icons:** Material Symbols Outlined

## 📄 Pages

### 1. **Home** (`index-formatted.html`)
- Product showcase
- Featured hampers grid
- Customer testimonials
- Newsletter signup

### 2. **Gift Customizer** (`gift-formatted.html`)
- Interactive hamper builder
- 4 category selection (base, sweets, flowers, accessories)
- Real-time price calculation
- Add to cart functionality

### 3. **About** (`about-formatted.html`)
- Brand story
- Mission statement
- Founder info (Tanvi)
- Company values
- WhatsApp contact button

### 4. **Policies** (`policy-formatted.html`)
- Terms of Service
- Privacy Policy
- Shipping Information
- Returns & Refunds

## 🛒 Core Features

### Shopping Cart (`src/js/cart.js`)
```javascript
// Add item
pookieCart.addItem(product);

// Get total
const total = pookieCart.getTotal('express');

// Get summary
const summary = pookieCart.getSummary();
```

### Hamper Customizer (`src/js/customizer.js`)
```javascript
// Create customizer
const customizer = new HamperCustomizer(products);

// Select items
customizer.selectItem('base', 'base-1', 25);
customizer.selectItem('sweets', 'sweet-1', 18);

// Create order
const order = customizer.createOrder();
```

### API Client (`src/js/api.js`)
```javascript
// Get products
const products = await pookieAPI.getProducts();

// Create order
const order = await pookieAPI.createOrder(orderData);

// Subscribe
await pookieAPI.subscribeNewsletter(email);
```

## 📦 Product Data

Products and customizer items are stored in `src/data/products.json`:

```json
{
  "hampers": [
    {
      "id": 1,
      "name": "The Classic Pookie",
      "price": 2499,
      "contents": ["Rose Truffles", "Lavender Flowers", ...],
      "rating": 4.8
    }
  ],
  "customizer_items": {
    "bases": [...],
    "sweets": [...],
    "flowers": [...],
    "accessories": [...]
  }
}
```

## ⚙️ Configuration

Edit `config.json` to customize:
- Site information
- Color scheme
- Payment methods
- Shipping options
- Feature flags

## 🔗 External Services

**Configured in `.env`:**
- Payment: Razorpay, Stripe, UPI
- Analytics: Google Analytics
- Email: Mailgun
- WhatsApp: Business API integration

## 📱 Responsive Design

- Mobile-first approach
- Tailwind CSS breakpoints
- Optimized for all screen sizes
- Touch-friendly interactions

## 🎯 Key Interactions

- **Heart Pop Animation** - Product interactions
- **Floating Effects** - Hero images
- **Smooth Scroll** - Policy anchors
- **Sparkle Particles** - About page
- **Real-time Pricing** - Customizer

## 🛠️ Technologies

- **Frontend:** HTML5, CSS3, JavaScript (ES6+)
- **Styling:** Tailwind CSS 3.4
- **Icons:** Material Symbols Outlined
- **Fonts:** Google Fonts (Plus Jakarta Sans, Outfit, Quicksand)
- **Build:** Tailwind CLI, PostCSS
- **Package Manager:** npm

## 📊 Browser Support

- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)

## 📝 License

MIT License © 2024 Pookie Hampers

## 👩‍💼 Creator

Built with ❤️ by Tanvi

---

**Questions?** Reach out via WhatsApp: +91-8779542727
