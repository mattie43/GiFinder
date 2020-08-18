# search giphy
require_relative '../config/environment.rb'


def img_test
    image = MiniMagick::Image.open("https://media.giphy.com/media/wHe2BPdK5moB6Rjy4d/giphy.gif")
    ImageOptimizer.new(image.path, quiet: true).optimize
    image.resize "100x100"
    # image2 = Magick::Image.read(image.path)
    # binding.pry

    # gif.frames #=> [...]
    # pdf.pages  #=> [...]
    # psd.layers #=> [...]

    # gif.frames.each_with_index do |frame, idx|
    # frame.write("frame#{idx}.jpg")
    # end

    # adding gifsicle to cut frames out
    # first_frame = gifsicle anim.gif '#0'

    gif_frames = image.frames.length - 1

    8.times do
    gif_frames.times do |x|
        Catpix::print_image image.frames[x].path,
        :limit_x => 1.0,
        :limit_y => 1.0,
        :center_x => false,
        :center_y => false,
        :bg => "white",
        :bg_fill => false,
        :resolution => "low"
        sleep(0.09)
        system 'clear'
    end
    end
    # end
    # image.contrast
    # image.resize "100x100"
    # image.write("anim.gif")

    # Catpix::print_image image.path,
    #     :limit_x => 1.0,
    #     :limit_y => 0,
    #     :center_x => true,
    #     :center_y => true,
    #     :bg => "white",
    #     :bg_fill => true,
    #     :resolution => "low"
    # binding.pry
end

def frame_one
    Catpix::print_image "firstframe.gif",
        :limit_x => 0.5,
        :limit_y => 0.5,
        :center_x => true,
        :center_y => true,
        :bg => "white",
        :bg_fill => false,
        :resolution => "low"
    sleep (0.09)
    system 'clear'  
end
def frame_two
    Catpix::print_image "secondframe.gif",
        :limit_x => 0.5,
        :limit_y => 0.5,
        :center_x => true,
        :center_y => true,
        :bg => "white",
        :bg_fill => false,
        :resolution => "low"
    sleep (0.09)
    system 'clear'  
end
def frame_three
    Catpix::print_image "thirdframe.gif",
        :limit_x => 0.5,
        :limit_y => 0.5,
        :center_x => true,
        :center_y => true,
        :bg => "white",
        :bg_fill => false,
        :resolution => "low"
    sleep (0.09)
    system 'clear'  
end

def gif_test
    system 'clear'
    5.times do
        frame_one
        frame_two
        frame_three
    end
end

def welcome_screen
    # stretch: put a cool welcome gif here
    puts "welcome screen check"
    # ask user to login or sign up
end


binding.pry
