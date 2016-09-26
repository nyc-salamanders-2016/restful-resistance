class GamesController < ApplicationController
  def index
    # for now,  giving the first user to current user when session is not set
    @currentUser = current_user || User.find(1)
    @currentGame = @currentUser.game
    @currentRound = @currentUser.game.rounds.last
    @countRounds = @currentUser.game.rounds.count
    @currentQuests = @currentUser.game.rounds.last.quests.last
    @countQuests = @currentUser.game.rounds.last.quests.count
    @gameUsers = @currentGame.users
    @gameStage = @currentGame.stage
  end

  def new
    redirect_to "/games" if current_user.good != nil
  end

  def create
    game = Game.create

    round = Round.create(game_id: game.id)
    # Creator is created here instead of in user controller.

    user = User.new(name: params[:name], creator: params[:creator], game_id: game.id)
    if user.save!
      session[:user_id] = user.id
      redirect_to '/games/new'
    end
  end

  def update
    currentUser = current_user || User.find(1)
    currentGame = currentUser.game
    currentQuest = currentGame.rounds.last.quests.last # this may be nill
    p "params are"
    p params[:response]
    @response = params[:response]
    currentGame.update(stage: @response)
    render json: @response.to_json
  end

# split into a post and get status

  def status
    #eventually this will be dynamic
    currentUser = current_user || User.find(1)
    gameStage = currentUser.game.stage
    # currentGame = currentuser.game # OR: Game.find(params[:game_id])
    # currentQuest = currentGame.rounds.last.quests.last
    # #if else for end game
    # if QuestVote.find_by(user_id: currentUser.id, quest_id: currentQuest.id)
    #   debugger
    #   @response = "questVoteDone" # change this to a better term!
    # else
    #   @response = "questVoting"
    # end
    render json: gameStage.to_json
  end

  private

end
