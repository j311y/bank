class Account
  MAXIMUM_OVERDRAFT = 0
  attr_reader :balance, :transactions
  def initialize(balance = MAXIMUM_OVERDRAFT)
    @balance = balance
    @transactions = []
  end

  def deposit(amount)
    raise 'You cannot deposit that amount' if amount < 0 || amount.zero?
    add_to_balance(amount)
    transactions_handler(Time.now.strftime('%D'), amount, nil, @balance)
    save_transactions
  end

  def withdraw(amount)
    raise 'You cannot withdraw that amount' if amount < 0 || amount.zero?
    raise 'You don\'t have enough funds for that transaction' if amount > @balance
    subtract_from_balance(amount)
    transactions_handler(Time.now.strftime('%D'), nil, amount, @balance)
    save_transactions
  end

  def statement
    header
    transactions_formatter(@transactions.reverse)
  end

  def load
    load_transactions
  end
  
  private

  attr_writer :balance, :transactions

  def add_to_balance(amount)
    self.balance += amount
  end

  def subtract_from_balance(amount)
    self.balance -= amount
  end

  def header
    puts "Account Statement at #{Time.now.strftime('%T on %a %e %b %Y')} \n"
  end

  def transactions_handler(date, credit, debit, balance)
    transactions << { date: date, credit: credit, debit: debit, balance: balance }
  end

  def transactions_formatter(transactions)
    index = 0
    puts "DATE || CREDIT || DEBIT || BALANCE"
    until index == transactions.count
      puts "#{transactions[index][:date]} || #{transactions[index][:credit]} || #{transactions[index][:debit]} || #{transactions[index][:balance]}"
      index += 1
    end
  end

  def save_transactions
    require 'csv'
    CSV.open('transactions.csv', 'w') { |csv|
      @transactions.each do |transaction|
        transaction_data = []
        transaction.each_value {|x| transaction_data << x }
        csv << transaction_data
      end
    }
  end

  def load_transactions
    require 'csv'
    CSV.open('transactions.csv', 'r') { |csv|
      CSV.foreach('transactions.csv') do |row|
        date, credit, debit, balance = row
        transactions_handler(date, credit, debit, balance)
      end
    }
  end
end
