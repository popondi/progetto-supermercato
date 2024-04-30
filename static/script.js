// Esempio di dati del carrello
const cartItems = [
    { name: "Prodotto 1", quantity: 2, price: 10.99 },
    { name: "Prodotto 2", quantity: 1, price: 5.99 },
    { name: "Prodotto 3", quantity: 3, price: 7.49 }
];

// Funzione per aggiornare il carrello
function updateCart() {
    const cartList = document.getElementById('cart-items');
    cartList.innerHTML = '';
    let totalPrice = 0;

    cartItems.forEach((item, index) => {
        const li = document.createElement('li');
        
        const productName = document.createElement('span');
        productName.textContent = item.name + " - Quantità: ";
        li.appendChild(productName);

        const decreaseBtn = document.createElement('button');
        decreaseBtn.className = "quantity-controls";
        decreaseBtn.textContent = "-";
        decreaseBtn.onclick = () => decreaseQuantity(index);
        li.appendChild(decreaseBtn);

        const quantityInput = document.createElement('input');
        quantityInput.type = "text"; // Cambiamo il tipo da "number" a "text"
        quantityInput.size = Math.max(item.quantity.toString().length, 1); // Impostiamo la larghezza in base alla lunghezza del numero
        quantityInput.value = item.quantity;

        quantityInput.classList.add("quantity-input");

        // Funzione per gestire l'evento keydown
        quantityInput.onkeydown = (event) => {
            // Se viene premuto il tasto Invio (codice 13)
            if (event.keyCode === 13) {
                const newValue = parseInt(event.target.value);
                if (!isNaN(newValue)) {
                    updateQuantity(index, newValue);
                }
                event.preventDefault(); // Impediamo il comportamento predefinito del tasto Invio (non invierà il modulo)
            }
        };

        // Funzione per gestire l'evento blur
        quantityInput.onblur = (event) => {
            const newValue = parseInt(event.target.value);
            if (!isNaN(newValue)) {
                updateQuantity(index, newValue);
            }
        };

        li.appendChild(quantityInput);

        const increaseBtn = document.createElement('button');
        increaseBtn.className = "quantity-controls";
        increaseBtn.textContent = "+";
        increaseBtn.onclick = () => increaseQuantity(index);
        li.appendChild(increaseBtn);

        const totalPriceSpan = document.createElement('span');
        totalPriceSpan.textContent = " Prezzo: $" + (item.quantity * item.price).toFixed(2);
        li.appendChild(totalPriceSpan);

        const removeBtn = document.createElement('button');
        removeBtn.className = "remove-button";
        removeBtn.textContent = "❌";
        removeBtn.onclick = () => removeItem(index);
        li.appendChild(removeBtn);

        cartList.appendChild(li);

        totalPrice += item.quantity * item.price;
    });

    document.getElementById('total-price').textContent = "$" + totalPrice.toFixed(2);
}

// Funzione per aggiornare la quantità del prodotto nel carrello
function updateQuantity(index, quantity) {
    if (quantity > 0) {
        cartItems[index].quantity = parseInt(quantity);
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

// Inizializza il carrello
updateCart();