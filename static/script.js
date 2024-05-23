// Funzione per aggiornare il carrello
function updateCart() {
    const cartList = document.getElementById('cart-items');
    let totalPrice = 0;

    // Aggiorna ogni elemento del carrello
    Array.from(cartList.children).forEach((li, index) => {
        const quantityInput = li.querySelector('.quantity-input');
        const totalPriceSpan = li.querySelector('.total-price');

        const item = cartItems[index];
        quantityInput.value = item.quantity;
        quantityInput.size = Math.max(item.quantity.toString().length, 1);
        totalPriceSpan.textContent = " Prezzo: " + (item.quantity * item.price).toFixed(2) + " €";

        totalPrice += item.quantity * item.price;
    });

    // Aggiorna il prezzo totale
    document.getElementById('total-price').textContent = totalPrice.toFixed(2) + " €";
}

// Funzione per aggiornare la quantità del prodotto nel carrello
function updateQuantity(index, quantity) {
    if (quantity > 0) {
        cartItems[index].quantity = quantity;
        updateCart();
    }
}

// Funzione per incrementare la quantità del prodotto nel carrello
function increaseQuantity(index) {
    cartItems[index].quantity++;
    updateCart();
}

// Funzione per ridurre la quantità del prodotto nel carrello
function decreaseQuantity(index) {
    if (cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
        updateCart();
    }
}

// Funzione per rimuovere un prodotto dal carrello
function removeItem(index) {
    cartItems.splice(index, 1);
    updateCart();
}

// Funzione per l'acquisto
function purchase() {
    alert("Grazie per il tuo acquisto!");
}

// Aggiunge gli eventi agli input di quantità
document.addEventListener('DOMContentLoaded', () => {
    const cartList = document.getElementById('cart-items');
    Array.from(cartList.children).forEach((li, index) => {
        const quantityInput = li.querySelector('.quantity-input');
        quantityInput.onkeydown = (event) => {
            if (event.keyCode === 13) {
                const newValue = parseInt(event.target.value);
                if (!isNaN(newValue)) {
                    updateQuantity(index, newValue);
                }
                event.preventDefault();
            }
        };

        quantityInput.onblur = (event) => {
            const newValue = parseInt(event.target.value);
            if (!isNaN(newValue)) {
                updateQuantity(index, newValue);
            }
        };
    });

    // Inizializza il carrello
    updateCart();
});

