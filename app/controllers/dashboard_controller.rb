class DashboardController < ApplicationController
  def index
    @income  = Transaction.total_income
    @expense = Transaction.total_expense
    @balance = Transaction.balance

    @by_category = Transaction.expense_by_category
    @monthly = Transaction.monthly_summary(months: 6)

    @recent = Transaction.order(occurred_on: :desc, id: :desc).limit(8)
    @transaction = Transaction.new(occurred_on: Date.current)
  end
end
