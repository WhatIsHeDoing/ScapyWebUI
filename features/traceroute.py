"""Trace route integration tests."""
from lettuce import before, step, world
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait

class WaitForHtmlToMatch(object):
    """Custom expected condition."""
    def __init__(self, locator, html):
        self.locator = locator
        self.html = html

    def __call__(self, driver):
        try:
            element = EC._find_element(driver, self.locator)
            return self.html in element.get_attribute("innerHTML")
        except:
            return False

@before.all
def before_all():
    world.driver = webdriver.Chrome()
    world.driver.get("http://127.0.0.1:5000")
    assert "Scapy" in world.driver.title

@step
def have_entered_the_domain(_, domain):
    '''I have entered the domain "(.*)"'''
    element = world.driver.find_element_by_id("domain")
    assert element is not None
    element.clear()
    element.send_keys(domain)

@step
def submit_the_form(_):
    element = world.driver.find_element_by_id("search")
    assert element is not None
    element.click()

@step
def see_an_error_message(_):
    try:
        WebDriverWait(world.driver, 5).until(
            EC.text_to_be_present_in_element((By.CLASS_NAME, "help-block"), "Oops")
        )
    except:
        assert False

@step
def see_a_graph(_):
    wait = WebDriverWait(world.driver, 20)

    try:
        graph = wait.until(WaitForHtmlToMatch((By.ID, "graph"), "<svg"))
        assert graph is not None
    except:
        assert False

@step
def see_a_table(_):
    wait = WebDriverWait(world.driver, 20)

    try:
        table = wait.until(WaitForHtmlToMatch((By.ID, "table"), "<table"))
        assert table is not None
    except:
        assert False
