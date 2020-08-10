require 'open-uri'

class GamesController < ApplicationController
  def new
    session[:score] = 0 if session[:score].nil?
    alphabets = ("a"..."z").to_a
    @letters = []
    15.times { @letters << alphabets.sample }
  end

  def score
    @letters = params[:grid].split(" ")
    reference = Hash.new{0}
    @attempt = params[:attempt]

    @letters.each do |letter|
      reference[letter] += 1
    end

    @attempt.chars.each do |letter|
      reference[letter] -= 1
    end

    url = "https://wagon-dictionary.herokuapp.com/#{@attempt}"
    word = JSON.parse(open(url).read)

    reference.each_value do |value|
      if value < 0
        @answer = "This can't be built from the given grid"
      elsif value >= 0 && word["found"]
        @answer = "Well done!"
        session[:score] += 1
      else
        @answer = "This is not an existing word"
      end
    end



  end
end


# url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
# word = JSON.parse(open(url).read)
