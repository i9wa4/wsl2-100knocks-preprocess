# wsl2-100knocks-preprocess

Set up [The-Japan-DataScientist-Society/100knocks-preprocess](https://github.com/The-Japan-DataScientist-Society/100knocks-preprocess) environment in WSL2.

## 1. Requirements

- WSL2 (Ubuntu 22.04 LTS)

## 2. Installation

1. Run Ubuntu and install make.

    ```sh
    sudo apt install -y make
    ```

1. Clone this repository.

    ```sh
    git clone https://github.com/i9wa4/wsl2-100knocks-preprocess ~/src/github.com/i9wa4/wsl2-100knocks-preprocess
    ```

1. Execute step1.

    ```sh
    cd ~/src/github.com/i9wa4/wsl2-100knocks-preprocess
    make setup-step1
    ```

1. Terminate Ubuntu & WSL2.

    ```sh
    exit
    ```

    ```dosbatch
    wsl --shutdown
    ```

1. Run Ubuntu.
1. Execute step2.

    ```sh
    cd ~/src/github.com/i9wa4/wsl2-100knocks-preprocess
    make setup-step2
    ```

## 3. How to run the container

1. Run the container.

    ```sh
    cd ~/src/github.com/i9wa4/wsl2-100knocks-preprocess
    make start-knock
    ```

1. Open [http://localhost:8888](http://localhost:8888).
1. Shut down JupyterLab.
1. Stop the container.

    ```sh
    make stop-knock
    ```
