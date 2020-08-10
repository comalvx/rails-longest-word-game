require 'open-uri'

class GamesController < ApplicationController
  def new
    session[:score] = 0 if session[:score].nil?
    alphabets = ("a"..."z").to_a
    @letters = []
    15.times { @letters << alphabets.sample }
  end

  def score

    if in_grid? && valid_word?
      @answer = "Well done!"
      session[:score] += params[:attempt].length
    elsif in_grid?
      @answer = "This is not a valid word"
    else
      @answer = "This can't be built based on the given words"
    end
  end

  private

  def in_grid?
    @letters = params[:grid].split(" ")
    reference = Hash.new{0}
    @attempt = params[:attempt]

    @letters.each do |letter|
      reference[letter] += 1
    end

    @attempt.chars.each do |letter|
      reference[letter] -= 1
    end

    reference.each_value do |value|
      return true if value >= 0
    end
  end

  def valid_word?
    url = "https://wagon-dictionary.herokuapp.com/#{@attempt}"
    word = JSON.parse(open(url).read)
    if word["found"]
      return true
    else
      return false
    end
  end
end


# url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
# word = JSON.parse(open(url).read)
