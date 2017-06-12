require 'account'

describe Account do
  subject(:account) { described_class.new }

  context 'Balance' do
    it 'has a start balance of 0' do
      expect(account.balance).to eq(0)
    end
  end

  context 'Deposit' do
    it 'allows a specified amount to be deposited' do
      expect { account.deposit(100) }.to change { account.balance }.by(100)
    end
    it 'only allows positive sums to be deposited' do
      expect { account.deposit(-50) }.to raise_error 'You cannot deposit that amount'
    end
    it 'does not allow nothing to be deposited' do
      expect { account.deposit(0) }.to raise_error 'You cannot deposit that amount'
    end
  end

  context 'Withdrawal' do
    it 'allows a specified amount to be withdrawn' do
      account.deposit(100)
      expect { account.withdraw(50) }.to change { account.balance }.by(-50)
    end
    it 'only allows positive sums to be withdrawn' do
      expect { account.withdraw(-50) }.to raise_error 'You cannot withdraw that amount'
    end
    it 'does not allow nothing to be withdrawn' do
      expect { account.withdraw(0) }.to raise_error 'You cannot withdraw that amount'
    end
    it 'does not allow a withdrawal if the balance would be less than 0' do
      account.deposit(100)
      expect { account.withdraw(101) }.to raise_error 'You don\'t have enough funds for that transaction'
    end
  end

  context 'Transactions' do
    before(:each) do
      account.deposit(100)
    end
    it 'records the date of the transaction (deposits)' do
      date = Time.now.strftime('%D')
      expect(account.transactions[0]).to include(date: date)
    end
    it 'records the ammount deposited' do
      expect(account.transactions[0]).to include(credit: 100)
    end
    it 'records the amount withdrawn' do
      account.withdraw(50)
      expect(account.transactions[1]).to include(debit: 50)
    end
    it 'records the balance at that time' do
      expect(account.transactions[0]).to include(balance: 100)
    end
  end
end
