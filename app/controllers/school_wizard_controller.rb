class SchoolWizardController < ApplicationController
  def states
    @states = School.states.dup
    if params[:country_id] == 'FR'
      @states.pop
      @states.unshift ['Choisir un département', '']
    else
      @states = [['Choisir un département', ''], @states.pop]
    end
  end

  def cities
    schools = School.where(country: params[:country_id],
                           state: params[:state_id])
    @cities = schools.map(&:city).uniq.sort if schools
  end

  def schools
    @schools = School.where(country: params[:country_id],
                            state: params[:state_id],
                            city: params[:city_id])
  end
end
