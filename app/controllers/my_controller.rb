# -*- coding: utf-8 -*-

# = マイページコントローラ
# Author:: Dolphin
# Date:: 2013.01.27
#
class MyController < ApplicationController

  def index
    @animes = Anime.find( :all )
    @episodes = Episode.find_by_member( @user )
  end

end
