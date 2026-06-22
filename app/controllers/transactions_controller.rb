class TransactionsController < ApplicationController
  def create
    @transaction = Transaction.new(transaction_params)
    if @transaction.save
      redirect_to root_path, notice: "Lançamento adicionado."
    else
      redirect_to root_path, alert: @transaction.errors.full_messages.to_sentence
    end
  end

  def destroy
    Transaction.find(params[:id]).destroy
    redirect_to root_path, notice: "Lançamento removido."
  end

  private

  def transaction_params
    params.require(:transaction).permit(:description, :kind, :category, :occurred_on, :amount)
          .tap { |p| p[:amount_cents] = (p.delete(:amount).to_f * 100).round }
  end
end
