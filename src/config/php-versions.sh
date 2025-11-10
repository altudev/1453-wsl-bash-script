#!/bin/bash
# PHP Version and Extension Configuration
# This file exports PHP-related configuration arrays

# PHP version list
export PHP_SUPPORTED_VERSIONS=("7.4" "8.1" "8.2" "8.3" "8.4" "8.5")

# PHP extension packages to install with each version
export PHP_EXTENSION_PACKAGES=("mbstring" "zip" "gd" "tokenizer" "curl" "xml" "bcmath" "intl" "sqlite3" "pgsql" "mysql" "fpm")