-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 20, 2023 at 05:16 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ecom_db`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetProductList` ()   BEGIN
SELECT p.product_id, p.product_name,
c.category_name, p.stock_quantity, p.price
FROM products p
JOIN categories c ON p.category_id = 
c.category_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertNewProduct` (IN `p_product_name` VARCHAR(75), IN `p_category_name` VARCHAR(75), IN `p_stock_quantity` INT, IN `p_price` DECIMAL(10,2))   BEGIN
    DECLARE p_category_id INT;
    
    IF p_product_name IS NULL OR
    p_category_name IS NULL OR p_stock_quantity IS
    NULL OR p_price IS NULL THEN 
    SELECT  "Please fill up the required parameters.";
    ELSE
    SELECT category_id INTO p_category_id FROM categories WHERE category_name=p_category_name;
     
    INSERT INTO products (product_name, category_id, stock_quantity, price)
    VALUES (p_product_name, p_category_id, p_stock_quantity, p_price);
    
    SELECT "Product inserted successfully." AS MESSAGE ;
    END IF;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PlaceOrder` (IN `p_customer_id` INT, IN `p_product_id` INT, IN `p_quantity` INT)   BEGIN
    DECLARE p_stock INT;
    DECLARE last_order_id INT;
   
    SELECT stock_quantity INTO p_stock FROM products WHERE product_id = p_product_id;
    
    IF p_stock IS NULL OR p_stock < p_quantity THEN
        SELECT "Product is out of stock" AS message;
    ELSE
        
        INSERT INTO orders (customer_id, order_date)
        VALUES (p_customer_id, CURDATE());
        
        SET last_order_id = LAST_INSERT_ID();
        
        INSERT INTO orders_items (order_items_id, order_id, product_id,quantity_id)
        VALUES (last_order_id, p_product_id, p_quantity, order_id);
        
  
        CALL UPDATEproductstock(p_product_id, p_stock - p_quantity);
        
        SELECT "Order placed successfully" AS message;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UPDATEproductstock` (IN `p_product_id` INT, IN `p_new_stock` INT)   BEGIN
UPDATE products
SET stock_quantity=p_new_stock
WHERE product_id=p_product_id;

SELECT "Stock quantity updated successfully" as message;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `category_id` int(11) NOT NULL,
  `category_name` varchar(75) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`category_id`, `category_name`) VALUES
(1, 'Shoes'),
(2, 'Clothes'),
(3, 'damit');

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `customer_id` int(11) NOT NULL,
  `first_name` varchar(35) NOT NULL,
  `last_name` varchar(35) NOT NULL,
  `email` varchar(75) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`customer_id`, `first_name`, `last_name`, `email`) VALUES
(1, 'Angelo', 'Buenaventura', 'AngeloSK@Gmail.com'),
(2, 'Alejo', 'Peteros', 'AlejandroGobernador@gmail.com');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `order_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `customer_id`, `order_date`) VALUES
(1, 1, '2023-10-20'),
(2, 1, '2023-10-20'),
(3, 1, '2023-10-20'),
(4, 1, '2023-10-20'),
(5, 1, '2023-10-20'),
(6, 1, '2023-10-20'),
(7, 1, '2023-10-20'),
(8, 1, '2023-10-20'),
(9, 2, '2023-10-20');

-- --------------------------------------------------------

--
-- Table structure for table `orders_items`
--

CREATE TABLE `orders_items` (
  `order_items_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders_items`
--

INSERT INTO `orders_items` (`order_items_id`, `order_id`, `product_id`, `quantity_id`) VALUES
(1, 0, 2, 1),
(2, 0, 2, 4),
(3, 0, 2, 3),
(5, 0, 2, 4),
(8, 2, 4, 2),
(9, 1, 69, 1);

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `product_id` int(11) NOT NULL,
  `product_name` varchar(75) NOT NULL,
  `category_id` int(11) NOT NULL,
  `stock_quantity` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`product_id`, `product_name`, `category_id`, `stock_quantity`, `price`) VALUES
(1, 'Kikee', 1, 31, 599.90),
(2, 'Balasubas', 2, 51, 499.90),
(3, 'Adidas', 1, 5, 696.90),
(4, 'dikit', 1, 100, 69.90),
(5, 'pants', 3, 500, 90.00);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`customer_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `orders_items`
--
ALTER TABLE `orders_items`
  ADD PRIMARY KEY (`order_items_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `customer_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `orders_items`
--
ALTER TABLE `orders_items`
  MODIFY `order_items_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
